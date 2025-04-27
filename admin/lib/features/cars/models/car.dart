class Car {
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
  final String ownerId;
  final String ownerName;
  final String ownerContact;
  final double rentalPricePerDay;
  final double rentalPricePerHour;
  final int minimumRentDuration;
  final double securityDeposit;
  final double lateFeePerHour;
  final double rentalExtendFeePerDay;
  final double rentalExtendFeePerHour;
  final List<String> images;
  final bool isAvailable;
  final int currentOdometerReading;
  final List<String>? damagesOrIssues;
  final DateTime createdAt;
  final DateTime updatedAt;

  Car({
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
    required this.ownerId,
    required this.ownerName,
    required this.ownerContact,
    required this.rentalPricePerDay,
    required this.rentalPricePerHour,
    required this.minimumRentDuration,
    required this.securityDeposit,
    required this.lateFeePerHour,
    required this.rentalExtendFeePerDay,
    required this.rentalExtendFeePerHour,
    required this.images,
    required this.isAvailable,
    required this.currentOdometerReading,
    this.damagesOrIssues,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      variant: json['variant'],
      fuelType: json['fuel_type'],
      transmission: json['transmission'],
      bodyType: json['body_type'],
      color: json['color'],
      seatingCapacity: json['seating_capacity'],
      vehicleNumber: json['vehicle_number'],
      ownerId: json['owner_id'],
      ownerName: json['owner_name'],
      ownerContact: json['owner_contact'],
      rentalPricePerDay: json['rental_price_per_day'].toDouble(),
      rentalPricePerHour: json['rental_price_per_hour'].toDouble(),
      minimumRentDuration: json['minimum_rent_duration'],
      securityDeposit: json['security_deposit'].toDouble(),
      lateFeePerHour: json['late_fee_per_hour'].toDouble(),
      rentalExtendFeePerDay: json['rental_extend_fee_per_day'].toDouble(),
      rentalExtendFeePerHour: json['rental_extend_fee_per_hour'].toDouble(),
      images: List<String>.from(json['images']),
      isAvailable: json['is_available'],
      currentOdometerReading: json['current_odometer_reading'],
      damagesOrIssues: json['damages_or_issues'] != null
          ? List<String>.from(json['damages_or_issues'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'variant': variant,
      'fuel_type': fuelType,
      'transmission': transmission,
      'body_type': bodyType,
      'color': color,
      'seating_capacity': seatingCapacity,
      'vehicle_number': vehicleNumber,
      'owner_id': ownerId,
      'owner_name': ownerName,
      'owner_contact': ownerContact,
      'rental_price_per_day': rentalPricePerDay,
      'rental_price_per_hour': rentalPricePerHour,
      'minimum_rent_duration': minimumRentDuration,
      'security_deposit': securityDeposit,
      'late_fee_per_hour': lateFeePerHour,
      'rental_extend_fee_per_day': rentalExtendFeePerDay,
      'rental_extend_fee_per_hour': rentalExtendFeePerHour,
      'images': images,
      'is_available': isAvailable,
      'current_odometer_reading': currentOdometerReading,
      'damages_or_issues': damagesOrIssues,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
