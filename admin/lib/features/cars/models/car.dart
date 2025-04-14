import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String id;
  final String name;
  final String model;
  final String licensePlate;
  final String location;
  final double hourlyRate;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Car({
    required this.id,
    required this.name,
    required this.model,
    required this.licensePlate,
    required this.location,
    required this.hourlyRate,
    required this.isAvailable,
    required this.createdAt,
    this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      licensePlate: json['license_plate'] as String,
      location: json['location'] as String,
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      isAvailable: json['is_available'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'license_plate': licensePlate,
      'location': location,
      'hourly_rate': hourlyRate,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Car copyWith({
    String? id,
    String? name,
    String? model,
    String? licensePlate,
    String? location,
    double? hourlyRate,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      licensePlate: licensePlate ?? this.licensePlate,
      location: location ?? this.location,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        model,
        licensePlate,
        location,
        hourlyRate,
        isAvailable,
        createdAt,
        updatedAt,
      ];
}