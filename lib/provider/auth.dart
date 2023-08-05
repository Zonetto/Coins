import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase/style/color.dart' as color;

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  bool isLoad = true;

  String? get user {
    return token;
  }

  bool? get isAuth {
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

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
    context,
  ) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCepf0aYZ_OJ3Yo8k0t4QZLQzyzFSeVNf4";
    try {
      final res = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw "${resData['error']['message']}";
      }
      _token = resData['email'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: color.appBarBackgroundColor,
          content: Text(
            "You are logged in with an account: $_token",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", _token!);
      await prefs.setString("userId", _userId!);
      await prefs.setString("expiryDate", _expiryDate!.toIso8601String());
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAuthLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("token") &&
        !prefs.containsKey("userId") &&
        !prefs.containsKey("expiryDate")) {
      return false;
    }
    final expiryDate = DateTime.parse(prefs.getString('expiryDate') as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _expiryDate = expiryDate;
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    _autoLogout();
    notifyListeners();

    return true;
  }

  Future<void> signUp(String email, String password, context) async {
    return _authenticate(email, password, "signUp", context);
  }

  Future<void> logIn(String email, String password, context) async {
    return _authenticate(email, password, "signInWithPassword", context);
  }

  void logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer =
        Timer(Duration(hours: timeToExpiry), logOut); // 2400 = 100 days
  }
}
