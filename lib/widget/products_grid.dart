import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      //like listview builder
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // products[i].iD,
            // products[i].title,
            // products[i].imageurl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // da le column
        crossAxisCount: 2, //3add column
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10, //space between columns
        mainAxisSpacing: 10, // space between rows
      ),
    );
  }
}
