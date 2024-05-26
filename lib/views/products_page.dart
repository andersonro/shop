import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_list_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/widgets/drawer_widget.dart';
import 'package:shop_app/views/widgets/product_item_widget.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Future _loadingProducts(BuildContext context) async {
    await Provider.of<ProductListProvider>(context, listen: false)
        .loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductListProvider productListProvider = Provider.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerencimaneto de Produtos'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.productForm);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        drawer: const DrawerWidget(),
        body: RefreshIndicator(
          onRefresh: () => _loadingProducts(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: productListProvider.itemsCount,
              itemBuilder: (context, index) => Column(
                children: [
                  ProductItemWidget(
                      productModel: productListProvider.items[index]),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
