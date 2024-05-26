import 'package:flutter/material.dart';
import 'package:shop_app/views/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).primaryColor,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Loja',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
