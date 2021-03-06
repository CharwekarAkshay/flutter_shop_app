import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool value) {
    isFavorite = value;
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    _setFavoriteValue(!isFavorite);
    notifyListeners();
    var url =
        "https://shopapplication-4e66b-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
        notifyListeners();
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
      notifyListeners();
    }
  }
}
