import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/provider/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItemModel;
  const CartItemWidget({super.key, required this.cartItemModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(cartItemModel.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) {
            return showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Tem certeza?'),
                  content: Text(
                      'Realmente você deseja remover o item ${cartItemModel.productName} do carrinho!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
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
          onDismissed: (_) {
            Provider.of<CartProvider>(context, listen: false)
                .removeItem(cartItemModel.productId);
          },
          background: Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
          child: ListTile(
            title: Text(cartItemModel.productName),
            subtitle: Text(
                'subtotal R\$ ${(cartItemModel.price * cartItemModel.quantity).toStringAsFixed(2)}'),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(cartItemModel.price.toStringAsFixed(2)),
                ),
              ),
            ),
            trailing: Text('${cartItemModel.quantity}x'),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
