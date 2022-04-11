import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/order_list.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:flutter_shop/pages/cart_page.dart';
import 'package:flutter_shop/pages/orders_page.dart';
import 'package:flutter_shop/pages/product_detail_page.dart';
import 'package:flutter_shop/pages/products_page.dart';
import 'package:flutter_shop/pages/products_overview_page.dart';
import 'package:flutter_shop/utils/app,_routes.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
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
          AppRoutes.HOME: (ctx) => ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.CART: (ctx) => const CartPage(),
          AppRoutes.ORDERS: (ctx) => const OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
        },
      ),
    );
  }
}
