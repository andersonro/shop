import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/orders_provider.dart';
import 'package:shop_app/provider/product_list_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/auth_or_home_page.dart';
import 'package:shop_app/views/cart_page.dart';
import 'package:shop_app/views/orders_page.dart';
import 'package:shop_app/views/product_detail_page.dart';
import 'package:shop_app/views/product_form_page.dart';
import 'package:shop_app/views/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductListProvider>(
          create: (_) => ProductListProvider('', '', []),
          update: (context, auth, previous) {
            return ProductListProvider(
                auth.token ?? '', auth.userId ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider('', '', []),
          update: (context, auth, previous) {
            return OrdersProvider(
                auth.token ?? '', auth.userId ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.blue,
          canvasColor: const Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Anton',
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(color: Colors.white)),
          ),
          appBarTheme: const AppBarTheme(
              color: Colors.blue,
              titleTextStyle: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Lato'),
              iconTheme: IconThemeData(color: Colors.white)),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        //home: const ProductsOverViewPage(),
        routes: {
          AppRoutes.auth_or_home: (ctx) => const AuthOrHomePage(),
          //AppRoutes.home: (ctx) => const ProductsOverViewPage(),
          AppRoutes.productDetail: (ctx) => const ProductDetailPage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.products: (ctx) => const ProductsPage(),
          AppRoutes.productForm: (ctx) => const ProductFormPage(),
        },
      ),
    );
  }
}
