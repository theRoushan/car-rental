class Car {
  final String id;
  final String name;
  final String model;
  final String licensePlate;
  final String location;
  final double hourlyRate;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Car({
    required this.id,
    required this.name,
    required this.model,
    required this.licensePlate,
    required this.location,
    required this.hourlyRate,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      licensePlate: json['license_plate'],
      location: json['location'],
      hourlyRate: json['hourly_rate'].toDouble(),
      isAvailable: json['is_available'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'updated_at': updatedAt.toIso8601String(),
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
} 