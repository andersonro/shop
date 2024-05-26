import 'package:shop_app/models/cart_item_model.dart';

class OrdersModel {
  final String id;
  final double total;
  final List<CartItemModel> products;
  final DateTime date;

  OrdersModel({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}
