import 'package:flutter/material.dart';
import 'package:flutter_shop/components/product_grid_item.dart';
import 'package:flutter_shop/model/product.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  final bool showFavoriteOnly;
  const ProductGridItem({
    Key? key,
    required this.showFavoriteOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = showFavoriteOnly ? provider.favoriteitems : provider.items;

    return GridView.builder(
      itemCount: loadedProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ProductItem(),
        ),
      ),
    );
  }
}
