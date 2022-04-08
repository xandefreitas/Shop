import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: FittedBox(
              child: Text(cartItem.price.toStringAsFixed(2)),
            ),
          ),
        ),
        title: Text(cartItem.name),
        subtitle: Text('Total: R\$ ${cartItem.price * cartItem.quantity}'),
        trailing: Text('${cartItem.quantity}x'),
      ),
    );
  }
}
