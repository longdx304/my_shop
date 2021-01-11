import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _authentication({
    String email,
    String password,
    String urlSegment,
  }) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBV0qKVyw-m9nL2Th1YUrOmMoGpM5c0mwE';
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp({String email, String password}) async {
    return _authentication(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> logIn({String email, String password}) async {
    return _authentication(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }
}
