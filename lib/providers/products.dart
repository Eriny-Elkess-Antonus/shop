import 'package:flutter/foundation.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   iD: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageurl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   iD: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageurl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   iD: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageurl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   iD: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageurl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // hanbtady 5twat 3shan awl lma a3ml loginn el product tzhar fe screen msh t3d t3ml load
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isfavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.iD == id);
  }

  //fetched data from system
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // n3ml refresh

    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https:shop-540fd-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString'; //kda b3d m3mlna loginn kol order hyro7 ll id mo7add bt3 kol sha5s
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          'https:shop-540fd-default-rtdb.firebaseio.com/UserFavorites/$userId.json?auth=$authToken'; //new value for this request
      final favoriteRsponse = await http.get(url);
      final favoriteData = json.decode(favoriteRsponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          iD: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isfavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageurl: prodData['imageurl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async //y3niah?
  {
    final url =
        'https:shop-540fd-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response =
          await http //byntazer 5twa de t5las w b3d kda tro7 ll 5twa el b3dha
              .post(
        url,
        body: json.encode({
          //send data to server firebase an store there
          'title': product.title, //mapping json
          'description': product.description,
          'imageurl': product.imageurl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageurl: product.imageurl,
        iD: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //lma 5twa el fo2 t5las a3ml kza

  Future<void> updateproduct(String id, Product newproduct) async {
    // 3amlna update ll product el gdeda 3la app w server
    final prodIndex = _items.indexWhere((prod) => prod.iD == id);
    if (prodIndex >= 0) {
      final url =
          'https:shop-540fd-default-rtdb.firebaseio.com/products$id.json?auth=$authToken';

      await http.patch(url,
          body: json.encode({
            //mapping of jason
            'title': newproduct.title,
            'description': newproduct.description,
            'imageurl': newproduct.imageurl,
            'price': newproduct.price,
          }));
      _items[prodIndex] = newproduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    // kda a7na 3amlna delete mn 3la server le kol product el adaft w mn 3la app kman
    final url =
        'https:shop-540fd-default-rtdb.firebaseio.com/products$id.json?auth=$authToken';
    final existingProductInex = _items.indexWhere((prod) => prod.iD == id);
    var existingProduct = _items[existingProductInex];
    _items.removeAt(existingProductInex);

    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductInex, existingProduct);
      notifyListeners();
      throw Http('Could not delete product. ');
    }
    existingProduct = null;
  }
}
