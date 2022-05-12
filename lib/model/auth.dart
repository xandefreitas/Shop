import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/exceptions/auth_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expireDate;
  Timer? _signOutTimer;

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
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expireDate = DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));
    }
    _autoSignOut();
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void signOut() {
    _token = null;
    _email = null;
    _userId = null;
    _expireDate = null;
    _clearSignOutTimer();
    notifyListeners();
  }

  void _clearSignOutTimer() {
    _signOutTimer?.cancel();
    _signOutTimer = null;
  }

  void _autoSignOut() {
    _clearSignOutTimer();
    final timeToSignOut = _expireDate?.difference(DateTime.now()).inSeconds;
    _signOutTimer = Timer(Duration(seconds: timeToSignOut ?? 0), signOut);
  }

  bool get isAuth {
    final _isValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && _isValid;
  }

  String? get token => isAuth ? _token : null;
  String? get email => isAuth ? _email : null;
  String? get userId => isAuth ? _userId : null;
}
