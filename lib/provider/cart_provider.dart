import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/models/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSigleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (value) => CartItemModel(
          id: value.id,
          price: value.price,
          productId: value.productId,
          productName: value.productName,
          quantity: value.quantity - 1,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void addItem(ProductModel productModel) {
    if (_items.containsKey(productModel.id)) {
      _items.update(
        productModel.id,
        (value) => CartItemModel(
          id: value.id,
          price: value.price,
          productId: value.productId,
          productName: value.productName,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          productModel.id,
          () => CartItemModel(
                id: Random().nextInt(10).toString(),
                price: productModel.price,
                productId: productModel.id,
                productName: productModel.title,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get amountCart {
    double total = 0.00;

    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }
}
