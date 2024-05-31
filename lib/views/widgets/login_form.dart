import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/utils/auth_exception.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, Object> formData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();
  var _typeLayout = TypeLayout.login;
  bool _isLoading = false;

  bool _isLogin() {
    return _typeLayout == TypeLayout.login;
  }

  bool _isRegister() {
    return _typeLayout == TypeLayout.register;
  }

  _toogleTypeLayout() {
    setState(() {
      _typeLayout = _isLogin() ? TypeLayout.register : TypeLayout.login;
    });
  }

  _showErrorAlert(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future _submitForm() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    AuthProvider authProvider = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await authProvider.login(
            email: formData['email'].toString(),
            password: formData['password'].toString());
      } else {
        //REGISTER
        await authProvider.register(
            email: formData['email'].toString(),
            password: formData['password'].toString());
      }
    } on AuthException catch (e) {
      _showErrorAlert(e.toString());
    } catch (e) {
      _showErrorAlert('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    var email = value ?? '';
                    if (email.isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail valido!';
                    }
                    return null;
                  },
                  onSaved: (value) => formData['email'] = value ?? ''),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  label: Text('Senha'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  var senha = value ?? '';
                  if (senha.trim().isEmpty) {
                    return 'A senha deve ser informada!';
                  }
                  if (senha.length < 6) {
                    return 'A senha deve possuir minimo de 6 caracteres!';
                  }
                  return null;
                },
                onSaved: (value) => formData['password'] = value ?? '',
              ),
              const SizedBox(height: 8),
              if (_isRegister())
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Confirmação de Senha'),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (value) {
                          var senha = value ?? '';
                          if (senha.trim().isEmpty) {
                            return 'A confirmação de senha deve ser preenchida!';
                          }
                          if (senha != _passwordController.text) {
                            return 'As senhas não conferem!';
                          }
                          return null;
                        },
                ),
              const SizedBox(height: 8),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(_isLogin() ? 'Entrar' : 'Registrar'),
                  ),
                ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _toogleTypeLayout(),
                child: Text(_isLogin() ? 'Criar conta' : 'Acessar conta'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

enum TypeLayout { login, register }
