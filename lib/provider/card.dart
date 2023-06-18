import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CartItem with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return _items;
  }

  int get cartLength {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCardItem) => CartItem(
              id: existingCardItem.id,
              title: existingCardItem.title,
              quantity: existingCardItem.quantity - 1,
              price: existingCardItem.price));
    }else{
      _items.remove(productId);
    }
  }

  void addItems(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingProduct) => CartItem(
              title: existingProduct.title,
              quantity: existingProduct.quantity + 1,
              price: existingProduct.price,
              id: existingProduct.id));
      notifyListeners();
    } else {
      _items.putIfAbsent(
          productId,
          () =>
              CartItem(title: title, quantity: 1, price: price, id: productId));
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
