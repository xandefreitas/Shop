import 'package:flutter/material.dart';
import 'package:flutter_shop/model/order.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(
              'R\$ ${widget.order.total.toStringAsFixed(2)}',
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
        ),
        if (_expanded)
          Container(
            height: (widget.order.products.length * 24.0) + 8,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListView(
                children: widget.order.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${product.quantity}x R\$ ${product.price}',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList()),
          ),
      ],
    );
  }
}
