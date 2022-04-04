import 'package:flutter/material.dart';
import 'package:flutter_shop/components/product_grid.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  FAVORITE,
  ALL,
}

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Loja',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.FAVORITE,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.ALL,
              ),
            ],
            onSelected: (selectedValue) {
              if (selectedValue == FilterOptions.FAVORITE) {
                provider.showFavoriteOnly();
              } else {
                provider.showAll();
              }
            },
          ),
        ],
        centerTitle: true,
      ),
      body: ProductGrid(),
    );
  }
}
