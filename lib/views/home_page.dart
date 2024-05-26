import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: const Text("Home"),
        ),
      ),
    );
  }
}
