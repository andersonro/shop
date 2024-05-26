class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}
