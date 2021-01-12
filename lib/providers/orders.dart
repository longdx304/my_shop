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
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://my-shop-8e0fa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final res = await http.get(url);
    final ordersData = json.decode(res.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];
    if (ordersData == null) return;
    ordersData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((cartItem) => CartItem(
                  id: cartItem['id'],
                  title: cartItem['title'],
                  price: cartItem['price'],
                  quantity: cartItem['quantity'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder({List<CartItem> cartProducts, double total}) async {
    final url =
        'https://my-shop-8e0fa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
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
