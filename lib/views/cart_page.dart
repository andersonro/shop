import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/orders_provider.dart';
import 'package:shop_app/views/widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of(context);
    final items = cartProvider.items.values.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Carrinho')),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    CartItemModel item = items[index];
                    return CartItemWidget(cartItemModel: item);
                  },
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL"),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                            'R\$ ${cartProvider.amountCart.toStringAsFixed(2)}'),
                        backgroundColor: Theme.of(context).primaryColor,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Provider.of<OrdersProvider>(
                            context,
                            listen: false,
                          ).addOrders(cartProvider);
                          cartProvider.clear();
                        },
                        child: const Text("Finalizar Comprar"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
