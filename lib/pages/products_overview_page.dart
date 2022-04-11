import 'package:flutter/material.dart';
import 'package:flutter_shop/components/app_drawer.dart';
import 'package:flutter_shop/components/badge.dart';
import 'package:flutter_shop/components/product_grid.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:flutter_shop/utils/app,_routes.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  FAVORITE,
  ALL,
}

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  _showFavoriteOnly = true;
                });
              } else {
                setState(() {
                  _showFavoriteOnly = false;
                });
              }
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.CART),
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: ProductGridItem(showFavoriteOnly: _showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
