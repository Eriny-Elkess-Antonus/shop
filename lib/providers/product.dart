import 'package:flutter/foundation.dart'; // ast5dmtha 3shan akteb @required
import 'package:provider/provider.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String iD;
  final String title;
  final String description;
  final String imageurl;
  final double price;
  bool isfavorite;
  Product(
      {@required this.iD,
      @required this.imageurl,
      @required this.description,
      @required this.price,
      @required this.title,
      this.isfavorite = false});

  void _setFavValue(bool newValue) {
    //ba5li lw m3mol like al3'y lw mshm3mol a3mlo
    isfavorite = newValue;
    notifyListeners();
  }

  Future<void> togglefavorite(String token, String userId) async {
    //kda a7na dfna el favorite 3la server
    final oldStatus = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();
    final url =
        'https:shop-540fd-default-rtdb.firebaseio.com/UserFavorites/$userId$iD.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isfavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
