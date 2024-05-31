import 'package:flutter/material.dart';
import 'package:shop_app/services/firebase_services.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future toogleFavorite(String token, String userId) async {
    final FireBaseServices service = FireBaseServices();

    try {
      _toogleFavorite();
      final response = await service.userFavoriteProduct(this, token, userId);

      if (response.statusCode >= 400) {
        _toogleFavorite();
      }
    } catch (_) {
      _toogleFavorite();
    }
  }
}
