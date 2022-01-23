// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';

import 'products_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future toggleFavoriteStatus(String token, String userId) async {
    final url = Uri.parse(
      'https://shopapp-4957d-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token',
    );
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode({
          'isFav': isFavorite ? 'true' : 'false',
        }),
      );
      if (response.statusCode >= 400) {
        _setFavorite(oldStatus);
        //throw HttpException('Can\'t favorite an item...');
      }
    } catch (error) {
      _setFavorite(oldStatus);
    }
  }
}
