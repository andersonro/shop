import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/models/orders_model.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/services/firebase_services.dart';

class OrdersProvider with ChangeNotifier {
  final FireBaseServices _service = FireBaseServices();

  List<OrdersModel> _items = [];
  String _token;
  String _userId;

  OrdersProvider(this._token, this._userId, this._items);

  List<OrdersModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future loadOrders() async {
    _items.clear();
    final res = await _service.loadOrders(_token, _userId);

    if (res == 'null') return;

    Map<String, dynamic> data = jsonDecode(res);
    data.forEach((key, value) {
      _items.add(
        OrdersModel(
          id: key,
          total: value['total'],
          products: (value['products'] as List<dynamic>).map((item) {
            return CartItemModel(
              id: item['id'],
              productId: item['productId'],
              productName: item['productName'],
              price: item['price'],
              quantity: item['quantity'],
            );
          }).toList(),
          date: DateTime.parse(value['date']),
        ),
      );
    });
    notifyListeners();
  }

  Future addOrders(CartProvider cart) async {
    var date = DateTime.now();

    OrdersModel ordersModel = OrdersModel(
      total: cart.amountCart,
      products: cart.items.values.toList(),
      date: date,
    );

    final response = await _service.addOrder(ordersModel, _token, _userId);

    final id = jsonDecode(response)['name'];

    _items.insert(
      0,
      OrdersModel(
        id: id,
        total: ordersModel.total,
        products: ordersModel.products,
        date: date,
      ),
    );

    notifyListeners();
  }
}
