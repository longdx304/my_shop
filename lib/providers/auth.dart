import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> _authentication(
      {String email, String password, String urlSegment}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBV0qKVyw-m9nL2Th1YUrOmMoGpM5c0mwE';
    final res = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    print(json.decode(res.body));
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
