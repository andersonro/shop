import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/exceptions/http_exception.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/services/firebase_services.dart';

class ProductListProvider with ChangeNotifier {
  final services = FireBaseServices();

  final List<ProductModel> _item = [];
  List<ProductModel> get items => [..._item];
  List<ProductModel> get itemsFavorite =>
      _item.where((element) => element.isFavorite).toList();

  int get itemsCount {
    return _item.length;
  }

  Future loadProducts() async {
    _item.clear();
    final res = await services.loadProducts();

    if (res == 'null') return;

    Map<String, dynamic> data = jsonDecode(res);
    data.forEach((key, value) {
      _item.add(
        ProductModel(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ),
      );
    });
    notifyListeners();
  }

  saveProduct(Map<String, Object> data) async {
    bool hasId = data['id'] != null;

    final product = ProductModel(
      id: hasId ? data['id'].toString() : Random().nextInt(10).toString(),
      title: data['name'].toString(),
      description: data['description'].toString(),
      price:
          double.tryParse(data['price'].toString().replaceAll(',', '.')) ?? 0,
      imageUrl: data['imageUrl'].toString(),
    );
    if (hasId) {
      return editProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future addProduct(ProductModel productModel) async {
    final _response = await services.addProduct(productModel);
    final _id = jsonDecode(_response)['name'];
    if (_id != 'null') {
      _item.add(
        ProductModel(
          id: _id,
          title: productModel.title,
          description: productModel.description,
          price: productModel.price,
          imageUrl: productModel.imageUrl,
        ),
      );
      notifyListeners();
    }
  }

  Future editProduct(ProductModel productModel) async {
    int index = _item.indexWhere((p) => p.id == productModel.id);
    if (index >= 0) {
      await services.editProduct(productModel);

      _item[index] = productModel;

      notifyListeners();
    }
  }

  Future delProduct(ProductModel productModel) async {
    int index = _item.indexWhere((p) => p.id == productModel.id);
    if (index >= 0) {
      final product = _item[index];
      _item.remove(product);
      notifyListeners();

      Response response = await services.deleteProduct(productModel);
      if (response.statusCode >= 400) {
        _item.insert(index, product);
        notifyListeners();
        throw HttpException(
            message: 'Erro ao deletar o registro',
            statusCode: response.statusCode);
      }
    }
  }
}
