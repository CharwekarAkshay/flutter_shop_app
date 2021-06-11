import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
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

  Future<void> fetchAndSetOrder() async {
    final url =
        "https://shopapplication-4e66b-default-rtdb.firebaseio.com/orders.json";
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      final List<OrderItem> loadedOrder = [];
      final extratedData = json.decode(response.body) as Map<String, dynamic>;
      if (extratedData == null) {
        return;
      }
      extratedData.forEach(
        (orderId, orderData) {
          loadedOrder.add(
            new OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (product) => CartItem(
                      id: product['id'],
                      title: product['title'],
                      quantity: product['quantity'],
                      price: product['price'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(
                orderData['dateTime'],
              ),
            ),
          );
        },
      );
      _orders = loadedOrder;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shopapplication-4e66b-default-rtdb.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(
            {
              "amount": total,
              "dateTime": timeStamp.toIso8601String(),
              "products": cartProducts
                  .map(
                    (cartProduct) => {
                      'id': cartProduct.id,
                      'title': cartProduct.title,
                      'quantity': cartProduct.quantity,
                      'price': cartProduct.price,
                    },
                  )
                  .toList(),
            },
          ));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
