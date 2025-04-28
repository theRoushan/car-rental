import 'package:equatable/equatable.dart';

enum BookingStatus {
  booked,
  cancelled,
  completed
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, email];
}

class Car extends Equatable {
  final String id;
  final String make;
  final String model;
  final int year;
  final String variant;
  final String fuelType;
  final String transmission;
  final String bodyType;
  final String color;
  final int seatingCapacity;
  final String vehicleNumber;

  const Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.variant,
    required this.fuelType,
    required this.transmission,
    required this.bodyType,
    required this.color,
    required this.seatingCapacity,
    required this.vehicleNumber,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      variant: json['variant'] as String,
      fuelType: json['fuel_type'] as String,
      transmission: json['transmission'] as String,
      bodyType: json['body_type'] as String,
      color: json['color'] as String,
      seatingCapacity: json['seating_capacity'] as int,
      vehicleNumber: json['vehicle_number'] as String,
    );
  }

  @override
  List<Object?> get props => [
    id,
    make,
    model,
    year,
    variant,
    fuelType,
    transmission,
    bodyType,
    color,
    seatingCapacity,
    vehicleNumber,
  ];
}

class Booking extends Equatable {
  final String id;
  final String userId;
  final User user;
  final String carId;
  final Car car;
  final String startTime;
  final String endTime;
  final BookingStatus status;
  final double totalPrice;

  const Booking({
    required this.id,
    required this.userId,
    required this.user,
    required this.carId,
    required this.car,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      carId: json['car_id'] as String,
      car: Car.fromJson(json['car'] as Map<String, dynamic>),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: _parseBookingStatus(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user': {
        'id': user.id,
        'name': user.name,
        'email': user.email,
      },
      'car_id': carId,
      'car': {
        'id': car.id,
        'make': car.make,
        'model': car.model,
        'year': car.year,
        'variant': car.variant,
        'fuel_type': car.fuelType,
        'transmission': car.transmission,
        'body_type': car.bodyType,
        'color': car.color,
        'seating_capacity': car.seatingCapacity,
        'vehicle_number': car.vehicleNumber,
      },
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
    user,
    carId,
    car,
    startTime,
    endTime,
    status,
    totalPrice,
  ];
}