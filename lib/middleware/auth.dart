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

  // ignore: non_constant_identifier_names
  final SERVER_IP = 'http://10.0.2.2:3000';
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
      print(response.body);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        storage.write(key: "jwtData", value: response.body);
      }
      _token = responseData["accessToken"];
      _userId = responseData["id"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<bool> tryAutoLogin() async {
  // final prefs = await SharedPreferences.getInstance();
  // if (!prefs.containsKey('userData')) {
  //   return false;
  // }
  // final extractedUserData = json.decode(prefs.getString('userData') as String)
  //     as Map<String, dynamic>;
  // final expiryDate =
  //     DateTime.parse(extractedUserData['expiryDate'] as String);

  // if (expiryDate.isBefore(DateTime.now())) {
  //   return false;
  // }
  // _token = extractedUserData['token'] as String;
  // _userId = extractedUserData['userId'] as String;
  // _expiryDate = expiryDate;
  // notifyListeners();
  // _autoLogout();
  // return true;
  // }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeout = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeout), logout);
  }
}
