// services/order_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';

class OrderService {
  static const String _ordersKey = 'orders';
  final _uuid = Uuid();

  // Add an order to history
  Future<void> addOrder({
    required String type,
    required String phoneNumber,
    required String amount,
    String provider = '',
    required String price,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getOrders();

    final newOrder = Order(
      id: _uuid.v4(),
      type: type,
      phoneNumber: phoneNumber,
      amount: amount,
      provider: provider,
      price: price,
      date: DateTime.now(),
    );

    orders.add(newOrder);

    final List<String> encodedOrders =
        orders.map((order) => jsonEncode(order.toMap())).toList();

    await prefs.setStringList(_ordersKey, encodedOrders);
  }

  // Get all orders
  Future<List<Order>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedOrders = prefs.getStringList(_ordersKey);

    if (encodedOrders == null) return [];

    return encodedOrders
        .map((orderStr) => Order.fromMap(jsonDecode(orderStr)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first
  }

  // ✅ Delete order by ID
  Future<void> deleteOrder(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getOrders();

    final updatedOrders =
        orders.where((order) => order.id != id).toList();

    final List<String> encodedOrders =
        updatedOrders.map((order) => jsonEncode(order.toMap())).toList();

    await prefs.setStringList(_ordersKey, encodedOrders);
  }
}
