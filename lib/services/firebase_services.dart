import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/product_model.dart';

class FireBaseServices {
  final _baseUrl = 'https://shop-aro-default-rtdb.firebaseio.com/products';

  Future addProduct(ProductModel productModel) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}.json'),
      body: jsonEncode(
        {
          "title": productModel.title,
          "description": productModel.description,
          "price": productModel.price,
          "imageUrl": productModel.imageUrl,
          "isFavorite": productModel.isFavorite,
        },
      ),
    );
  }

  Future editProduct(ProductModel productModel) async {
    final response = await http.patch(
      Uri.parse('${_baseUrl}/${productModel.id}.json'),
      body: jsonEncode(
        {
          "title": productModel.title,
          "description": productModel.description,
          "price": productModel.price,
          "imageUrl": productModel.imageUrl,
          "isFavorite": productModel.isFavorite,
        },
      ),
    );

    return response;
  }

  Future deleteProduct(ProductModel productModel) async {
    final response = await http.delete(
      Uri.parse('${_baseUrl}/${productModel.id}.json'),
    );

    return response;
  }

  Future loadProducts() async {
    final response = await http.get(Uri.parse('${_baseUrl}.json'));
    return response.body;
  }
}
