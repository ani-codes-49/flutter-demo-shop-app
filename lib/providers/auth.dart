// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  dynamic _token;
  dynamic _expiryDate;
  dynamic _userId;
  dynamic _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

  dynamic get userId {
    return _userId;
  }

  dynamic get token {
    if (_token != null && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String emailId, String password, String urlDecider) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlDecider?key=AIzaSyDkGA_kVxLOWYoltHp3mHEV9lhNcknYbI0');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': emailId,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    try {
      final extractedData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }

      _token = extractedData['token'] as String;
      _userId = extractedData['userId'] as String;
      _expiryDate = expiryDate;
      notifyListeners();
      autoLogout();
    } catch (error) {
      print(error);
    }
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _timestoExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timestoExpiry), logout);
  }
}
