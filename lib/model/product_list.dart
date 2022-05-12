import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop/exceptions/http_exception.dart';
import 'package:flutter_shop/model/product.dart';
import 'package:flutter_shop/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final String token;
  final String userId;
  List<Product> items = [];

  ProductList({
    this.token = '',
    this.items = const [],
    this.userId = '',
  });

  final _baseUrl = Constants.PRODUCT_BASE_URL;

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products.json?auth=$token'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> loadProducts() async {
    List<Product> _items = [];
    final response = await http.get(Uri.parse('$_baseUrl/products.json?auth=$token'));
    if (response.body == 'null') return;
    final favoriteResponse = await http.get(Uri.parse('$_baseUrl/userFavorites/$userId.json?auth=$token'));
    Map<String, dynamic> data = jsonDecode(response.body);
    Map<String, dynamic> favoriteData = favoriteResponse.body == 'null' ? {} : jsonDecode(favoriteResponse.body);
    data.forEach(
      (id, data) {
        final isFavorite = favoriteData[id] ?? false;
        _items.add(
          Product(
            id: id,
            name: data['name'],
            description: data['description'],
            imageUrl: data['imageUrl'],
            price: data['price'],
            isFavorite: isFavorite,
          ),
        );
      },
    );
    items = _items;
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
      price: data['price'] as double,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/products/${product.id}.json?auth=$token'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );
      items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      final product = items[index];
      items.remove(product);
      notifyListeners();
      final response = await http.delete(Uri.parse('$_baseUrl/products/${product.id}.json?auth=$token'));

      if (response.statusCode >= 400) {
        items.insert(index, product);
        notifyListeners();
        throw HttpException(
          message: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }

  List<Product> get itemsList => [...items];
  int get itemsCount => items.length;
  List<Product> get favoriteitems => items.where((element) => element.isFavorite).toList();

  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return _items.where((element) => element.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

}
