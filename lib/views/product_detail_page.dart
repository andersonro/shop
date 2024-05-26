import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel productModel =
        ModalRoute.of(context)!.settings.arguments as ProductModel;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(productModel.title)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.network(productModel.imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'R\$ ${productModel.price}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  productModel.description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
