import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      // shakl fe corner kol sora 3mlna carve fe atraf sora
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          //ba5ali elsora ka zorzr
          onTap: () {
            Navigator.of(context).pushNamed(
              //lma ados 3aleha hayt5l 3la screen tanya
              ProductDetailScreen.routeName,
              arguments: product.iD,
            );
          },
          child: Image.network(
            product.imageurl,
            fit: BoxFit.cover, // 3amleen msafa mazbota bean swar
          ),
        ),
        footer: GridTileBar(
          //bar 3la sora
          backgroundColor: Colors.black87, //lwana bar
          leading: IconButton(
            // hatena icon favorite 3la bar
            icon: Icon(
                product.isfavorite ? Icons.favorite : Icons.favorite_border), // ka2nna bnbadl da aw da 3la 7asb ah el magood
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.togglefavorite(authData.token, authData.userId,);
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.iD, product.price, product.title);
              //like notification
              Scaffold.of(context).hideCurrentSnackBar();// 3shan lma atlob bsor3a y5tfi ll awlnya w tzhar ll gdeda
              Scaffold.of(context).showSnackBar(
                // kol dol 5was clas scaffold
                // scaffold hna 3shan y3mli 7aga sare3a
                SnackBar(
                  //klas bar zay notification y2oli anta dost 3la 7aga el htshtreha aw ra7t fe orders byzhar a5r el screen
                  content: Text(
                    'Added item to cart',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),// da class 3shan y5li bar yzhar lmodt ad ah
                  action: SnackBarAction(// 3shan hnhot zorar fe bar 
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.iD);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
