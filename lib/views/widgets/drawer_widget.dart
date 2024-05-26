import 'package:flutter/material.dart';
import 'package:shop_app/utils/app_routes.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: const Text('Bem vindo usuário'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home),
              leading: const Icon(Icons.shop),
              title: const Text('Loja'),
            ),
            const Divider(),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.orders),
              leading: const Icon(Icons.payment),
              title: const Text('Pedidos'),
            ),
            const Divider(),
            ListTile(
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.products),
              leading: const Icon(Icons.edit),
              title: const Text('Gerenciar Produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
