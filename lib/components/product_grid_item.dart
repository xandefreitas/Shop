import 'package:flutter/material.dart';
import 'package:flutter_shop/model/auth.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/product.dart';
import 'package:flutter_shop/utils/app,_routes.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final message = ScaffoldMessenger.of(context);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.PRODUCT_DETAIL,
            arguments: product,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () async {
                try {
                  await product.toggleFavorite(auth.token ?? '', auth.userId ?? '');
                  if (product.isFavorite) {
                    message.hideCurrentSnackBar();
                    message.showSnackBar(
                      SnackBar(
                        content: Text('Produto adicionado aos favoritos!'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'DESFAZER',
                          onPressed: () => product.toggleFavorite(
                            auth.token ?? '',
                            auth.userId ?? '',
                          ),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  message.hideCurrentSnackBar();
                  message.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              message.hideCurrentSnackBar();
              message.showSnackBar(
                SnackBar(
                  content: Text('Produto adicionado com sucesso!'),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
