// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  // ignore: unused_field
  String? _userId;
  Timer? _authTimer;

  final SERVER_IP = 'http://10.0.2.2:3000';
  // final SERVER_IP = 'http://localhost:3000';
  final storage = FlutterSecureStorage();

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> signin(String email, String password) async {
    try {
      final response = await http.post(Uri.parse("$SERVER_IP/api/auth/signin"),
          body: {"email": email, "password": password});
      final responseData = json.decode(response.body);
      print("Auth Succes");
      print(responseData);
      if (response.statusCode == 200) {
        _token = responseData["accessToken"];
        _userId = responseData["id"];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData["expiresIn"])));
        _autoLogout();
        notifyListeners();
        final userData = json.encode(
          {
            'accessToken': _token,
            'id': _userId,
            'expiresIn': _expiryDate!.toIso8601String(),
          },
        );
        await storage.write(key: "jwtData", value: userData);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    String? value = await storage.read(key: "jwtData");
    if (value == null) {
      return false;
    }
    final extractedUserData = json.decode(value) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiresIn'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['accessToken'] as String;
    _userId = extractedUserData['id'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await storage.delete(key: "jwtData");
  }

  Future<void> _autoLogout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeout = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeout), logout);
  }
}
