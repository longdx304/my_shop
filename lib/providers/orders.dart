import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> addOrder({List<CartItem> cartProducts, double total}) async {
    final url = 'https://my-shop-8e0fa-default-rtdb.firebaseio.com/orders.json';
    final timestap = DateTime.now();
    final res = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestap.toIso8601String(),
        'products': cartProducts
            .map((cartProduct) => {
                  'id': cartProduct.id,
                  'price': cartProduct.price,
                  'quantity': cartProduct.quantity,
                  'title': cartProduct.title,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        dateTime: timestap,
        products: cartProducts,
        amount: total,
      ),
    );
    notifyListeners();
  }
}
