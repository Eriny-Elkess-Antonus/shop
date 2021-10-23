import 'package:flutter/foundation.dart';
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({this.amount, this.dateTime, this.id, this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // lma ados zorar shera2
    final url =
        'https:shop-540fd-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
