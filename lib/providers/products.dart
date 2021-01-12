import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite == true).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      var url =
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products.json?auth=$authToken';
      final res = await http.get(url);
      final Map<String, dynamic> products = json.decode(res.body);
      final List<Product> loadedProduct = [];
      if (products == null) return;
      url =
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);
      products.forEach((productId, product) => loadedProduct.add(Product(
            id: productId,
            description: product['title'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            isFavorite: favData == null ? false : favData[productId] ?? false,
          )));
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url =
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products.json?auth=$authToken';
      final res = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items.add(
        Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      final url =
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[itemIndex] = product;
      notifyListeners();
    } else {
      print('Error updating product');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final itemIndex = _items.indexWhere((item) => item.id == id);
    var item = _items[itemIndex];

    _items.removeAt(itemIndex);
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(itemIndex, item);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    item = null;
  }
}
