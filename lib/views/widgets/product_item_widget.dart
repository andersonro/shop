import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/product_list_provider.dart';
import 'package:shop_app/utils/app_routes.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel productModel;
  const ProductItemWidget({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productModel.imageUrl),
      ),
      title: Text(productModel.title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.productForm, arguments: productModel);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Tem certeza?'),
                      content: Text(
                          'Realmente você deseja remover o item ${productModel.title}?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            try {
                              await Provider.of<ProductListProvider>(context,
                                      listen: false)
                                  .delProduct(productModel);
                              Navigator.of(context).pop(true);
                            } catch (e) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: const Text('Sim'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Não'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
