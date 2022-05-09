import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/cart_item.dart';
import 'package:flutter_shop/model/order.dart';
import 'package:flutter_shop/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String _token;
  List<Order> _items = [];
  OrderList(this._token, this._items);

  final _baseUrl = Constants.PRODUCT_BASE_URL;
  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('$_baseUrl/orders.json?auth=$_token'),
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
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await http.get(Uri.parse('$_baseUrl/orders.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach(
      (id, data) => items.add(
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
    _items = items.reversed.toList();
    notifyListeners();
  }
}
