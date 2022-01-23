import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import 'Product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final String token;
  final String userId;

  Products(this.token, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchandSetProducts([bool filterByUser = false]) async {
    final valueString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId' : '';

    final url = Uri.parse(
      'https://shopapp-4957d-default-rtdb.firebaseio.com/products.json?auth=$token&$valueString"',
    );
    final result = await http.get(url);
    final response = json.decode(result.body) as Map<String, dynamic>;

    final favoriteResponse = await http.get(Uri.parse(
        'https://shopapp-4957d-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token'));

    final favoriteData = json.decode(favoriteResponse.body);

    List<Product> _temp = [];
    response.forEach((id, data) {
      _temp.add(
        Product(
          id: id,
          title: data['title'],
          price: data['price'],
          description: data['description'],
          imageUrl: data['imageUrl'],
          isFavorite: favoriteData[id] == null
              ? false
              : favoriteData[id]['isFav'] == 'true'
                  ? true
                  : false,
        ),
      );
    });
    _items = _temp;
    notifyListeners();
  }

  Future<void> addProducts(Product product) async {
    final url = Uri.parse(
      'https://shopapp-4957d-default-rtdb.firebaseio.com/products.json?auth=$token',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
    } catch (error) {
      print(error);
      rethrow;
    }

    //_items.add(value);
    notifyListeners();
  }

  Product findbyId(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://shopapp-4957d-default-rtdb.firebaseio.com/products/$id.json?auth=$token',
      );
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future deleteProduct(String id) async {
    final url = Uri.parse(
      'https://shopapp-4957d-default-rtdb.firebaseio.com/products/$id.json?auth=$token',
    );
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items.elementAt(existingProductIndex);

    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product');
    }
    existingProduct = Product(
      id: '',
      description: '',
      imageUrl: '',
      price: 0.00,
      title: '',
      isFavorite: false,
    );
  }
}
