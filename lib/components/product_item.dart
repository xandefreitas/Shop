import 'package:flutter/material.dart';
import 'package:flutter_shop/model/product.dart';
import 'package:flutter_shop/utils/app,_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.PRODUCT_FORM,
                arguments: product,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
