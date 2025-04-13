import 'car.dart';
import 'user.dart';

enum BookingStatus {
  booked,
  cancelled,
  completed;

  String get displayName => name.toUpperCase();
}

class Booking {
  final String id;
  final String userId;
  final String carId;
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final double totalPrice;
  final User? user;
  final Car? car;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
    this.user,
    this.car,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      carId: json['car_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: BookingStatus.values.firstWhere(
        (e) => e.displayName == json['status'],
        orElse: () => BookingStatus.booked,
      ),
      totalPrice: json['total_price'].toDouble(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'car_id': carId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status.displayName,
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? carId,
    DateTime? startTime,
    DateTime? endTime,
    BookingStatus? status,
    double? totalPrice,
    User? user,
    Car? car,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      user: user ?? this.user,
      car: car ?? this.car,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 