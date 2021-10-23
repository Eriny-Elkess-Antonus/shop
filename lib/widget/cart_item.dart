import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItem({this.id, this.price, this.quantity, this.title, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // widget bt5li y3ml remove ll 7aga b2no y7rkha lmeen aw shemal fa ttms7
      key: ValueKey(id), //tab3ha
      background: Container(
        // b3ml container yde lon 3shan akon shyfah w ana b7rako
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection
          .endToStart, // ba7dd atgah a7rkha mn anhi atah 3shan ams7 rigt to left
      //notification
      // onDismissed:(direction){Provider.of<Cart>(context, listen: false).removeItem(productId);}// bnade ll mas7 w bsam3 e kol 7ta
      confirmDismiss: (direction) {
        // byzharli notfication lma bms7 w anta thot rl 3awzo hna hs2alo mot2kd 3awz tl3'y el order
        return showDialog(
            // hya de asas el so2al el yzhar lma t7b t3ml notfication
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: [
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx)
                            .pop(false); // a5trt pop 3shan showdialog
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
      },

      onDismissed: (direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${price}'),
                ),
              ), // 3mlna fitt 3shan nzbt el klam 3la ad shakl w klo ykon wad7
            ),
            title: Text(title),
            subtitle: Text('Total:\$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
