import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final String authToken;
  final String userId;

  Cart(this.authToken, this.userId, this._items);

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchAndSetCart() async {
    var url = 'https://flutter-update-firebase.firebaseio.com/cart/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      _items = {};
      notifyListeners();
      return;
    }
    final Map<String, CartItem> cartItems = {};
    extractedData.forEach((productId, productData) {
      cartItems.putIfAbsent(
          productData['id'],
          () => CartItem(
                id: productId,
                title: productData['title'],
                quantity: productData['quantity'],
                price: productData['price'],
              ));
    });
    _items = cartItems;
    notifyListeners();
  }

  Future<void> addItem(
    String productId,
    double price,
    String title,
  ) async {
    var url = 'https://flutter-update-firebase.firebaseio.com/cart/$userId.json?auth=$authToken';

    if (_items.containsKey(productId)) {
      var id = _items[productId].id;
      url = 'https://flutter-update-firebase.firebaseio.com/cart/$userId/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'quantity': _items[productId].quantity + 1,
          }));

      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      final submit = await http.post(url,
          body: json.encode({
            'id': productId,
            'title': title,
            'price': price,
            'quantity': 1,
          }));
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: json.decode(submit.body)['name'],
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    var id = _items[productId].id;
    var url = 'https://flutter-update-firebase.firebaseio.com/cart/$userId/$id.json?auth=$authToken';
    await http.delete(url);
    _items.remove(productId);
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity == 1) removeItem(productId);
    if (_items[productId].quantity > 1) {
      var id = _items[productId].id;
      var url = 'https://flutter-update-firebase.firebaseio.com/cart/$userId/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'quantity': _items[productId].quantity - 1,
          }));
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    }
    notifyListeners();
  }

  Future<void> clear() async {
    _items = {};
    notifyListeners();
    var url = 'https://flutter-update-firebase.firebaseio.com/cart/$userId.json?auth=$authToken';
    await http.delete(url);
  }
}
