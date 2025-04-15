import 'package:equatable/equatable.dart';

enum BookingStatus {
  booked,
  cancelled,
  completed
}

class Booking extends Equatable {
  final String id;
  final String userId;
  final String carId;
  final String startTime;
  final String endTime;
  final BookingStatus status;
  final double totalPrice;
  final String createdAt;
  final String updatedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      carId: json['car_id'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: _parseBookingStatus(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'car_id': carId,
      'start_time': startTime,
      'end_time': endTime,
      'status': status.toString().split('.').last.toUpperCase(),
      'total_price': totalPrice,
    };
  }

  static BookingStatus _parseBookingStatus(String value) {
    switch (value.toUpperCase()) {
      case 'BOOKED': return BookingStatus.booked;
      case 'CANCELLED': return BookingStatus.cancelled;
      case 'COMPLETED': return BookingStatus.completed;
      default: return BookingStatus.booked;
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    carId,
    startTime,
    endTime,
    status,
    totalPrice,
    createdAt,
    updatedAt,
  ];
} 