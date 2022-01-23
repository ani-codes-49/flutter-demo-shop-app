import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart' show CartItem;

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://shopapp-4957d-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token',
    );

    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((orderId, orderValue) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderValue['amount'],
            dateTime: DateTime.parse(orderValue['dateTime']),
            products: (orderValue['products'] as List<dynamic>)
                .map(
                  (prod) => CartItem(
                    id: prod['id'],
                    price: prod['price'],
                    quantity: prod['quantity'],
                    title: prod['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://shopapp-4957d-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token',
    );

    final time = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': time.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: time,
      ),
    );
    notifyListeners();
  }
}
