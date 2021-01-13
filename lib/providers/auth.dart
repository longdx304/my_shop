import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

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

  String get userId {
    if (token == null) return null;
    return _userId;
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
      _userId = resData['localId'];
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expireDate': _expireDate.toIso8601String(),
        'userId': _userId,
      });
      prefs.setString('userData', userData);
      autoLogOut();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final userData =
        await json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expireDate = DateTime.parse(userData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) return false;
    _token = userData['token'];
    _expireDate = expireDate;
    _userId = userData['userId'];
    autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> signUp({String email, String password}) async {
    return _authentication(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> logIn({String email, String password}) async {
    return _authentication(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void autoLogOut() {
    if (_authTimer != null) _authTimer.cancel();
    final timeToExpire = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}
