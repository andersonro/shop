import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/models/orders_model.dart';
import 'package:shop_app/provider/cart_provider.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModel> _items = [];

  List<OrdersModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrders(CartProvider cart) {
    _items.insert(
      0,
      OrdersModel(
        id: Random().nextDouble().toString(),
        total: cart.amountCart,
        products: cart.items.values.toList(),
        date: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
