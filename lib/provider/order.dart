import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'card.dart';
import 'package:http/http.dart' as http;

const uuid = Uuid();

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

class Order with ChangeNotifier {

  final String authToken;
  Order(this.authToken, this._orders, this.userId);
  List<OrderItem> _orders = [];
  final String userId;

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> addOrder(List<CartItem> cardProducts, double total) async {
    final dateTime = DateTime.now();
    final url = "https://ecom-21bb9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            "amount": total,
            "products": cardProducts
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "quantity": cp.quantity,
                      "price": cp.price
                    })
                .toList(),
            "dateTime": dateTime.toIso8601String(),
          }));
      _orders.insert(
          0,
          OrderItem(
            amount: total,
            products: cardProducts,
            dateTime: dateTime,
            id: jsonDecode(response.body)['name'],
          ));
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchData() async {
    final url = "https://ecom-21bb9-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extratedData = jsonDecode(response.body);
      if(extratedData == null){
        return;
      }
      List<OrderItem> loadedOrder = [];
      extratedData.forEach((orderId, orderData) => loadedOrder.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])))); 
          _orders = loadedOrder.reversed.toList();
    } catch (e) {
      print(e);
      rethrow;
    }
    notifyListeners();
  }


  Future<void> deleteOrder(String id) async{
    final orderIndex = _orders.indexWhere((order) => order.id == id);
    final extractedOrder = _orders[orderIndex];
    _orders.removeAt(orderIndex);
    notifyListeners();
    final url = "https://ecom-21bb9-default-rtdb.firebaseio.com/orders/$userId/$id.json?auth=$authToken";
    try{
     final response = await http.delete(Uri.parse(url));
     if(response.statusCode >= 400){
      print("yeha");
      _orders.insert(orderIndex, extractedOrder);
      notifyListeners();
     }
    }catch(e){
      print(e);
      _orders.insert(orderIndex, extractedOrder);
      notifyListeners();
      rethrow;
    }

  }
}
