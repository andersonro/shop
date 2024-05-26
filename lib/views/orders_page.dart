import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders_provider.dart';
import 'package:shop_app/views/widgets/drawer_widget.dart';
import 'package:shop_app/views/widgets/orders_items_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos'),
        ),
        drawer: const DrawerWidget(),
        body: ListView.builder(
          itemCount: ordersProvider.itemsCount,
          itemBuilder: (context, index) {
            return OrdersItemsWidget(ordersModel: ordersProvider.items[index]);
          },
        ),
      ),
    );
  }
}
