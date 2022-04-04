import 'package:flutter/material.dart';
import 'package:flutter_shop/data/dummy_data.dart';
import 'package:flutter_shop/model/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  List<Product> get items => [..._items];
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
