import 'package:flutter/material.dart';
import 'package:flutter_shop/components/app_drawer.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('')),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (ctx, i) => Text(products.items[i].name),
        ),
      ),
    );
  }
}
