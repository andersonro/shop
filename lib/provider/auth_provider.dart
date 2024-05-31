import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/data/store_data.dart';
import 'package:shop_app/services/firebase_services.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiresDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiresDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token! : null;
  }

  String? get email {
    return isAuth ? _email! : null;
  }

  String? get userId {
    return isAuth ? _userId! : null;
  }

  final FireBaseServices _service = FireBaseServices();

  Future login({required String email, required String password}) async {
    final response = await _service.auth(
        email: email, password: password, typeAuth: 'login');

    _token = response['idToken'];
    _email = response['email'];
    _userId = response['localId'];

    _expiresDate =
        DateTime.now().add(Duration(seconds: int.parse(response['expiresIn'])));

    await _saveUserStore(
        token: _token!,
        email: _email!,
        userId: _userId!,
        expiresDate: _expiresDate!);

    _autoLogout();
    notifyListeners();
  }

  Future register({required String email, required String password}) async {
    final response = await _service.auth(
        email: email, password: password, typeAuth: 'register');

    _token = response['idToken'];
    _email = response['email'];
    _userId = response['localId'];

    _expiresDate =
        DateTime.now().add(Duration(seconds: int.parse(response['expiresIn'])));

    await _saveUserStore(
        token: _token!,
        email: _email!,
        userId: _userId!,
        expiresDate: _expiresDate!);

    notifyListeners();
  }

  Future<bool> _saveUserStore(
      {required String token,
      required String email,
      required String userId,
      required DateTime expiresDate}) async {
    return await StoreData.saveMap(
      'userData',
      {
        'token': token,
        'email': email,
        'userId': userId,
        'expiresDate': expiresDate.toIso8601String()
      },
    );
  }

  Future<bool> _loadUserStore() async {
    final data = await StoreData.getMap('userData');

    if (data['token'] == null) {
      return false;
    }

    _token = data['token'];
    _email = data['email'];
    _userId = data['userId'];
    _expiresDate = DateTime.parse(data['expiresDate']);

    return true;
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    if (await _loadUserStore() == false) return;

    if (_expiresDate!.isBefore(DateTime.now())) return;

    _autoLogout();
    notifyListeners();
  }

  logout() {
    _token = '';
    _email = '';
    _userId = '';
    _expiresDate = null;
    _clearAutoLogout();
    StoreData.removeString('userData').then((value) {
      notifyListeners();
    });
  }

  _clearAutoLogout() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  _autoLogout() {
    // controle de tempo de expiração
    _clearAutoLogout();

    final time = _expiresDate?.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(Duration(seconds: time ?? 0), logout);
  }
}
