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

  Auth();

  final SERVER_IP = 'http://10.0.2.2:3001';
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
    // Future<void> signin(String email, String password, http.Client client) async {
    final response = await http.post
        // final response = await client.post
        (Uri.parse("$SERVER_IP/api/auth/signin"),
            body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Auth Succes");
      var rolesList = responseData["roles"] as List<dynamic>;
      if (rolesList.contains("ROLE_SALESPERSON")) {
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
        await storage.write(
            key: "jwtData",
            value: userData); //Should comment this line for unit testing
      } else {
        throw Exception('Use a Salesperson Account to login');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Incorrect Email');
    } else if (response.statusCode == 401) {
      throw Exception('Wrong Password');
    } else {
      throw Exception('Auth');
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
    await storage.delete(
        key: "jwtData"); //Should comment this line for unit testing
  }

  Future<void> _autoLogout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeout = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeout), logout);
  }
}
