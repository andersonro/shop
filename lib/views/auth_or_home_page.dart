import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/views/login_page.dart';
import 'package:shop_app/views/products_overview_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);

    //return auth.isAuth ? const ProductsOverViewPage() : const LoginPage();

    return SafeArea(
      child: FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.error != null) {
            return const Scaffold(
              body: Center(
                child: Text('Houve um erro inesperado'),
              ),
            );
          } else {
            return auth.isAuth
                ? const ProductsOverViewPage()
                : const LoginPage();
          }
        },
      ),
    );
  }
}
