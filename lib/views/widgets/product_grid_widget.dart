import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/product_list_provider.dart';
import 'package:shop_app/views/widgets/product_item_grid_widget.dart';

class ProductGridWidget extends StatelessWidget {
  final bool isShowFavoriteOnly;
  const ProductGridWidget({super.key, required this.isShowFavoriteOnly});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListProvider>(context);
    final List<ProductModel> loadProducts =
        isShowFavoriteOnly ? provider.itemsFavorite : provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: loadProducts.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: loadProducts[index],
          child: const ProductItemGridWidget(),
        );
      },
    );
  }
}
