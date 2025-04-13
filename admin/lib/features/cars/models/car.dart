import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String color;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      color: json['color'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'color': color,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Car copyWith({
    String? id,
    String? brand,
    String? model,
    String? year,
    String? color,
    double? price,
    String? imageUrl,
    bool? isAvailable,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        brand,
        model,
        year,
        color,
        price,
        imageUrl,
        isAvailable,
        description,
        createdAt,
        updatedAt,
      ];
} 