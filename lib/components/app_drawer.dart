import 'package:flutter/material.dart';
import 'package:flutter_shop/model/auth.dart';
import 'package:flutter_shop/utils/app,_routes.dart';
import 'package:provider/provider.dart';

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
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Loja'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.AUTH_OR_HOME),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.ORDERS),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produtos'),
            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.PRODUCTS),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, AppRoutes.AUTH_OR_HOME);
            },
          ),
        ],
      ),
    );
  }
}
