import 'package:flutter/material.dart';
import 'package:flutter_shop/model/auth.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/order_list.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:flutter_shop/pages/auth_page.dart';
import 'package:flutter_shop/pages/cart_page.dart';
import 'package:flutter_shop/pages/orders_page.dart';
import 'package:flutter_shop/pages/product_detail_page.dart';
import 'package:flutter_shop/pages/product_form_page.dart';
import 'package:flutter_shop/pages/products_page.dart';
import 'package:flutter_shop/pages/products_overview_page.dart';
import 'package:flutter_shop/utils/app,_routes.dart';
import 'package:provider/provider.dart';

import 'pages/auth_or_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              token: auth.token ?? '',
              userId: auth.userId ?? '',
              items: previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              token: auth.token ?? '',
              userId: auth.userId ?? '',
              items: previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Shop',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.amber,
            secondary: Colors.deepOrange,
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  color: Colors.black,
                ),
              ),
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.CART: (ctx) => const CartPage(),
          AppRoutes.ORDERS: (ctx) => const OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
        },
      ),
    );
  }
}
