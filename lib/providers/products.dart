import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

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
      const url =
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products.json';
      final res = await http.get(url);
      final Map<String, dynamic> products = json.decode(res.body);
      final List<Product> loadedProduct = [];
      products.forEach((productId, product) => loadedProduct.add(Product(
            id: productId,
            description: product['title'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            isFavorite: product['isFavorite'],
          )));
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      const url =
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products.json';
      final res = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
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
          'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products/$id.json';
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
        'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products/$id';
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
