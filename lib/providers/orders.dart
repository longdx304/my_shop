import 'package:flutter/foundation.dart';

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    this.id,
    this.amount,
    this.dateTime,
    this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder({List<CartItem> cartProducts, double total}) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        dateTime: DateTime.now(),
        products: cartProducts,
        amount: total,
      ),
    );
    notifyListeners();
  }
}
