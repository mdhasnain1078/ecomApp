import 'dart:async';
import 'dart:convert';

import 'package:ecomapp/model/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId{
    return _userId;
  }

  Future<void> _authantication(
      String email, String password, String urlSegament) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegament?key=AIzaSyBilAgfCFYHm1l2ZegpJJXeNENKeuBRIso';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({"userId": _userId, "token": _token, "expiryDate": _expiryDate!.toIso8601String()});
      prefs.setString("userData", userData);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authantication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authantication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData")){
      return false;
    }
    final extrectedUserData = jsonDecode(prefs.getString("userData")!) as Map<String , dynamic>;
    final expiryDate = DateTime.parse(extrectedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _userId = extrectedUserData['userId'];
    _token = extrectedUserData['token'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;

  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove("userData");
    prefs.clear();
  }


  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds:timeToExpiry), ()=> logout());
  }
}
