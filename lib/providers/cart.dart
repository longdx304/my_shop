import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    var amount = 0.0;
    _items.forEach((key, item) => amount += item.price * item.quantity);
    return amount;
  }

  int get quantityCount {
    var quantity = 0;
    _items.forEach((key, item) => quantity += item.quantity);
    return quantity;
  }

  void addItem({String productId, String title, double price}) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingItem) {
        return CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
