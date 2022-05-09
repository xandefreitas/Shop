import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/exceptions/auth_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> _authenticate(String email, String password, String urlFragment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyCACLHqrYJmNrlvyLSQF-WXbKF6mfwYcF8';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
