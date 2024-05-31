import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/orders_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/utils/auth_exception.dart';

class FireBaseServices {
  Future addProduct(ProductModel productModel, String token) async {
    final response = await http.post(
      Uri.parse('${FireBaseUrls.productUrlBase}.json?auth=$token'),
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

  Future editProduct(ProductModel productModel, String token) async {
    final response = await http.patch(
      Uri.parse(
          '${FireBaseUrls.productUrlBase}/${productModel.id}.json?auth=$token'),
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

  Future deleteProduct(ProductModel productModel, String token) async {
    final response = await http.delete(
      Uri.parse(
          '${FireBaseUrls.productUrlBase}/${productModel.id}.json?auth=$token'),
    );

    return response;
  }

  Future loadProducts({required String token}) async {
    final response = await http
        .get(Uri.parse('${FireBaseUrls.productUrlBase}.json?auth=$token'));

    return response.body;
  }

  Future addOrder(OrdersModel ordersModel, String token, String userId) async {
    final response = await http.post(
      Uri.parse('${FireBaseUrls.ordersUrlBase}/$userId.json?auth=$token'),
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

  Future loadOrders(String token, String userId) async {
    final response = await http.get(
        Uri.parse('${FireBaseUrls.ordersUrlBase}/$userId.json?auth=$token'));

    return response.body;
  }

  Future auth(
      {required String email,
      required String password,
      required String typeAuth}) async {
    final response = await http.post(
      Uri.parse(typeAuth == 'register'
          ? FireBaseUrls.accountsRegisterUrlBase
          : FireBaseUrls.accountsLoginUrlBase),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    }

    return body;
  }

  Future userFavoriteProduct(
      ProductModel productModel, String token, String userId) async {
    final response = await http.put(
      Uri.parse(
          '${FireBaseUrls.userFavoriteProductUrlBase}/$userId/${productModel.id}.json?auth=$token'),
      body: jsonEncode(productModel.isFavorite),
    );

    return response;
  }

  Future userFavorites(String token, String userId) async {
    final response = await http.get(
      Uri.parse(
          '${FireBaseUrls.userFavoriteProductUrlBase}/$userId.json?auth=$token'),
    );

    return response.body;
  }
}

class FireBaseUrls {
  static String productUrlBase =
      'https://shop-aro-default-rtdb.firebaseio.com/products';
  static String ordersUrlBase =
      'https://shop-aro-default-rtdb.firebaseio.com/orders';
  static String accountsRegisterUrlBase =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCrdw-tAK9Cjbza46YxxAb-sLw6jbZBo-I';
  static String accountsLoginUrlBase =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCrdw-tAK9Cjbza46YxxAb-sLw6jbZBo-I';
  static String userFavoriteProductUrlBase =
      'https://shop-aro-default-rtdb.firebaseio.com/userFavorite';
}
