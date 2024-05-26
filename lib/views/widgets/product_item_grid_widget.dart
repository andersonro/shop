import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/utils/app_routes.dart';

class ProductItemGridWidget extends StatelessWidget {
  const ProductItemGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            productModel.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {
              productModel.toogleFavorite();
            },
            icon: Icon(productModel.isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
          ),
          trailing: IconButton(
            onPressed: () {
              cartProvider.addItem(productModel);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item adicionado com sucesso!'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      cartProvider.removeSigleItem(productModel.id);
                    },
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.productDetail, arguments: productModel);
          },
          child: Image.network(
            productModel.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
