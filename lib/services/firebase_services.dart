import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/orders_model.dart';
import 'package:shop_app/models/product_model.dart';

class FireBaseServices {
  Future addProduct(ProductModel productModel) async {
    final response = await http.post(
      Uri.parse('${FireBaseUrls.productUrlBase}.json'),
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
    return response.body;
  }

  Future editProduct(ProductModel productModel) async {
    final response = await http.patch(
      Uri.parse('${FireBaseUrls.productUrlBase}/${productModel.id}.json'),
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
      Uri.parse('${FireBaseUrls.productUrlBase}/${productModel.id}.json'),
    );

    return response;
  }

  Future loadProducts() async {
    final response =
        await http.get(Uri.parse('${FireBaseUrls.productUrlBase}.json'));
    return response.body;
  }

  Future addOrder(OrdersModel ordersModel) async {
    final response = await http.post(
      Uri.parse('${FireBaseUrls.ordersUrlBase}.json'),
      body: jsonEncode(
        {
          "total": ordersModel.total,
          "date": ordersModel.date.toIso8601String(),
          "products": ordersModel.products
              .map((e) => {
                    "id": e.id,
                    "productName": e.productName,
                    'productId': e.productId,
                    "quantity": e.quantity,
                    "price": e.price,
                  })
              .toList(),
        },
      ),
    );
    return response.body;
  }

  Future loadOrders() async {
    final response =
        await http.get(Uri.parse('${FireBaseUrls.ordersUrlBase}.json'));

    return response.body;
  }
}

class FireBaseUrls {
  static String _baseUrl = 'https://shop-aro-default-rtdb.firebaseio.com';
  static String productUrlBase = '$_baseUrl/products';
  static String ordersUrlBase = '$_baseUrl/orders';
}
