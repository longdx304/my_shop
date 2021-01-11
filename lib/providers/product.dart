import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _rollBackFav(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
    throw HttpException('Could not mark product as favorite.');
  }

  Future<void> toogleFavoriteStatus(String authToken) async {
    var existingFav = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://my-shop-8e0fa-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    try {
      final res = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (res.statusCode >= 400) {
        _rollBackFav(existingFav);
      }
    } catch (error) {
      _rollBackFav(existingFav);
    }
  }
}
