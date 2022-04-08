import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/app,_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem Vindo Usuário'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Loja'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.HOME),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.ORDERS),
          ),
        ],
      ),
    );
  }
}
