import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders_provider.dart';
import 'package:shop_app/views/widgets/drawer_widget.dart';
import 'package:shop_app/views/widgets/orders_items_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrdersProvider>(context, listen: false)
        .loadOrders()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos'),
        ),
        drawer: const DrawerWidget(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ordersProvider.itemsCount,
                itemBuilder: (context, index) {
                  return OrdersItemsWidget(
                      ordersModel: ordersProvider.items[index]);
                },
              ),
      ),
    );
  }
}
