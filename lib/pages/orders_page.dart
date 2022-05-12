import 'package:flutter/material.dart';
import 'package:flutter_shop/components/app_drawer.dart';
import 'package:flutter_shop/components/order_widget.dart';
import 'package:flutter_shop/model/order_list.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<OrderList>(context, listen: false).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshOrders(context),
              child: ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) {
                  return OrderWidget(
                    order: orders.items[i],
                  );
                },
              ),
            ),
    );
  }

  Future<void> _refreshOrders(BuildContext context) {
    setState(() => _isLoading = true);
    return Provider.of<OrderList>(context, listen: false).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
  }
}
