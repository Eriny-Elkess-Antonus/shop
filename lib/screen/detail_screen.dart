import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
              child: Column(// lma ados 3la 7aga el 3awzaha btft7 screen tanya w da el hyzhar gwaha
          children: [
            Container(height: 300,
            width: double.infinity,
            child: Image.network(loadedProduct.imageurl,
            fit: BoxFit.cover,),
            ),
            SizedBox(height: 10),// adef b3d mn mesa7a
            Text('\$${loadedProduct.price}',style: TextStyle(color: Colors.grey,
            fontSize: 20,),),
            SizedBox(height:10,),// bdef b3d mn el mwesa7a
             Container(
               padding: EdgeInsets.symmetric(horizontal:10 ),
               width: double.infinity,
               child: Text(loadedProduct.description,textAlign: TextAlign.center,
               softWrap:true , ),
             ),
          ],
        ),
      ),
    );
  }
}
