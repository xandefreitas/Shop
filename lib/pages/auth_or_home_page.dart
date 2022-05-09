import 'package:flutter/material.dart';
import 'package:flutter_shop/model/auth.dart';
import 'package:flutter_shop/pages/auth_page.dart';
import 'package:flutter_shop/pages/products_overview_page.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return auth.isAuth ? ProductsOverviewPage() : AuthPage();
  }
}
