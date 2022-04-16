import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop/data/dummy_data.dart';
import 'package:flutter_shop/model/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
      price: data['price'] as double,
    );
    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      _items.removeWhere((element) => element.id == product.id);
      notifyListeners();
    }
  }

  List<Product> get items => [..._items];
  int get itemsCount => _items.length;
  List<Product> get favoriteitems => _items.where((element) => element.isFavorite).toList();

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
