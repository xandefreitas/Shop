import 'package:flutter/material.dart';
import 'package:flutter_shop/components/product_item.dart';
import 'package:flutter_shop/model/product.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:provider/provider.dart';

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Loja',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (ctx, i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductItem(product: loadedProducts[i]),
        ),
      ),
    );
  }
}
