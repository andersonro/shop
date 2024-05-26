import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/product_list_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/widgets/drawer_widget.dart';
import 'package:shop_app/views/widgets/product_grid_widget.dart';

class ProductsOverViewPage extends StatefulWidget {
  const ProductsOverViewPage({super.key});

  @override
  State<ProductsOverViewPage> createState() => _ProductsOverViewPageState();
}

class _ProductsOverViewPageState extends State<ProductsOverViewPage> {
  bool isShowFavoriteOnly = false;
  bool isLoading = true;

  _toggleShowFavorite(bool fg) {
    setState(() {
      isShowFavoriteOnly = fg;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadingProducts();
  }

  _loadingProducts() async {
    await Provider.of<ProductListProvider>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Loja'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: const Text('Apenas Favoritos'),
                  onTap: () {
                    _toggleShowFavorite(true);
                  },
                ),
                PopupMenuItem(
                  child: const Text('Todos'),
                  onTap: () {
                    _toggleShowFavorite(false);
                  },
                ),
              ],
            ),
            Consumer<CartProvider>(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.cart);
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              builder: (ctx, cart, child) => Badge(
                label: Text('${cart.itemsCount}'),
                alignment: Alignment.lerp(
                    Alignment.topCenter, Alignment.centerRight, 0.5),
                isLabelVisible: cart.itemsCount > 0 ? true : false,
                textStyle: const TextStyle(fontSize: 10),
                child: child,
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ProductGridWidget(
                isShowFavoriteOnly: isShowFavoriteOnly,
              ),
        drawer: const DrawerWidget(),
      ),
    );
  }
}
