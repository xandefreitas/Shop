import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/product_detail_page.dart';
import 'package:flutter_shop/pages/products_overview_page.dart';
import 'package:flutter_shop/utils/app,_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
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
      home: ProductsOverviewPage(),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
      },
    );
  }
}
