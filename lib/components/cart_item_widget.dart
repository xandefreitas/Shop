import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cart.dart';
import 'package:flutter_shop/model/cart_item.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.productId);
      },
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem Certeza?'),
            content: Text('Quer remover o item do carrinho?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Sim'),
              ),
            ],
          ),
        );
      },
      child: Card(
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
      ),
    );
  }
}
