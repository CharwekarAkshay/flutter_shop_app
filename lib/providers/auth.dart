import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  // String? _token;
  // DateTime? _expiryDate;
  // String? _userId;

  static const API_KEY = "AIzaSyDwFvg-69bgou2FWpchak3wab0sFONJgk0";

  Future<void> _authenticate(
      String email, String password, String urlSegnment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegnment?key=$API_KEY";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final responseData  = json.decode(response.body);
      if(responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
