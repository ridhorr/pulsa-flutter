// models/order.dart
class Order {
  final String id;
  final String type; // "pulsa" or "kuota"
  final String phoneNumber;
  final String amount; // either nominal or package name
  final String provider; // only for kuota
  final String price;
  final DateTime date;

  Order({
    required this.id,
    required this.type,
    required this.phoneNumber,
    required this.amount,
    this.provider = '',
    required this.price,
    required this.date,
  });

  // Convert Order to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'phoneNumber': phoneNumber,
      'amount': amount,
      'provider': provider,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  // Create Order from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      type: map['type'],
      phoneNumber: map['phoneNumber'],
      amount: map['amount'],
      provider: map['provider'] ?? '',
      price: map['price'],
      date: DateTime.parse(map['date']),
    );
  }
}
