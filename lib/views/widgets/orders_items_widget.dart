import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/orders_model.dart';

class OrdersItemsWidget extends StatefulWidget {
  final OrdersModel ordersModel;
  const OrdersItemsWidget({super.key, required this.ordersModel});

  @override
  State<OrdersItemsWidget> createState() => _OrdersItemsWidgetState();
}

class _OrdersItemsWidgetState extends State<OrdersItemsWidget> {
  bool isExpanded = false;

  _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('R\$ ${widget.ordersModel.total.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy HH:mm')
                .format(widget.ordersModel.date)
                .toString()),
            trailing: IconButton(
              onPressed: () {
                _toggleExpanded();
              },
              icon: const Icon(Icons.expand_more),
            ),
          ),
          if (isExpanded)
            Container(
              height: (widget.ordersModel.products.length * 25.0) + 20,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              child: ListView(
                children: widget.ordersModel.products.map((el) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        el.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text('${el.quantity}x R\$ ${el.price}')
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
