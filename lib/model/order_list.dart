import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/cart_item.dart';
import 'package:flutter_shop/model/order.dart';
import 'package:flutter_shop/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String token;
  final String userId;
  List<Order> items = [];
  OrderList({
    this.token = '',
    this.userId = '',
    this.items = const [],
  });

  final _baseUrl = Constants.PRODUCT_BASE_URL;
  List<Order> get itemsList => [...items];

  int get itemsCount => items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    List<Order> _items = [];
    final response = await http.post(
      Uri.parse('$_baseUrl/userOrders/$userId.json?auth=$token'),
      body: jsonEncode(
        {
          "total": cart.totalAmount,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map((e) => {
                    'id': e.id,
                    'productId': e.productId,
                    'name': e.name,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    items = _items;
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> _items = [];
    final response = await http.get(Uri.parse('$_baseUrl/orders/$userId.json?auth=$token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach(
      (id, data) => _items.add(
        Order(
          id: id,
          total: data['total'],
          date: DateTime.parse(data['date']),
          products: (data['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    productId: e['productId'],
                    name: e['name'],
                    quantity: e['quantity'],
                    price: e['price'],
                  ))
              .toList(),
        ),
      ),
    );
    items = _items.reversed.toList();
    notifyListeners();
  }
}
