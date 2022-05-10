import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/exceptions/http_exception.dart';
import 'package:flutter_shop/utils/constants.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  final _baseUrl = Constants.PRODUCT_BASE_URL;

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    _toggleFavorite();
    final response = await http.put(
      Uri.parse('$_baseUrl/userFavorite/$userId/$id.json?auth=$token'),
      body: jsonEncode(isFavorite),
    );
    if (response.statusCode >= 400) {
      _toggleFavorite();
      throw HttpException(
        message: 'Não foi possível favoritar o item',
        statusCode: response.statusCode,
      );
    }
  }
}
