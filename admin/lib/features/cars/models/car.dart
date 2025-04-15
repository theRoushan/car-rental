import 'package:equatable/equatable.dart';

enum FuelType {
  petrol,
  diesel,
  electric,
  hybrid
}

enum TransmissionType {
  manual,
  automatic,
  cvt
}

enum BodyType {
  sedan,
  suv,
  hatchback,
  coupe,
  van,
  truck
}

class Car extends Equatable {
  final String id;
  final String make;
  final String model;
  final int year;
  final String variant;
  final FuelType fuelType;
  final TransmissionType transmission;
  final BodyType bodyType;
  final String color;
  final int seatingCapacity;
  final String vehicleNumber;
  final String registrationState;
  
  // Owner info
  final String ownerId;
  final String? ownerName;
  final String? ownerContact;
  
  // Location
  final String? currentLocation;
  final List<String>? availableBranches;
  
  // Rental info
  final double? rentalPricePerDay;
  final double? rentalPricePerHour;
  final int? minimumRentDuration;
  final int? maximumRentDuration;
  final double? securityDeposit;
  final double? lateFeePerHour;
  final String? discounts;
  
  // Media
  final List<String>? images;
  final String? video;
  
  // Status
  final bool isAvailable;
  final double? currentOdometerReading;
  final String? lastServiceDate;
  final String? nextServiceDue;
  final String? damagesOrIssues;
  
  final String createdAt;
  final String updatedAt;

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
    required this.registrationState,
    required this.ownerId,
    this.ownerName,
    this.ownerContact,
    this.currentLocation,
    this.availableBranches,
    this.rentalPricePerDay,
    this.rentalPricePerHour,
    this.minimumRentDuration,
    this.maximumRentDuration,
    this.securityDeposit,
    this.lateFeePerHour,
    this.discounts,
    this.images,
    this.video,
    this.isAvailable = true,
    this.currentOdometerReading,
    this.lastServiceDate,
    this.nextServiceDue,
    this.damagesOrIssues,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      variant: json['variant'] as String,
      fuelType: _parseFuelType(json['fuel_type'] as String),
      transmission: _parseTransmission(json['transmission'] as String),
      bodyType: _parseBodyType(json['body_type'] as String),
      color: json['color'] as String,
      seatingCapacity: json['seating_capacity'] as int,
      vehicleNumber: json['vehicle_number'] as String,
      registrationState: json['registration_state'] as String,
      ownerId: json['owner_id'] as String,
      ownerName: json['owner_name'] as String?,
      ownerContact: json['owner_contact'] as String?,
      currentLocation: json['current_location'] as String?,
      availableBranches: json['available_branches'] != null 
          ? List<String>.from(json['available_branches'] as List)
          : null,
      rentalPricePerDay: json['rental_price_per_day'] != null 
          ? (json['rental_price_per_day'] as num).toDouble() 
          : null,
      rentalPricePerHour: json['rental_price_per_hour'] != null 
          ? (json['rental_price_per_hour'] as num).toDouble() 
          : null,
      minimumRentDuration: json['minimum_rent_duration'] as int?,
      maximumRentDuration: json['maximum_rent_duration'] as int?,
      securityDeposit: json['security_deposit'] != null 
          ? (json['security_deposit'] as num).toDouble() 
          : null,
      lateFeePerHour: json['late_fee_per_hour'] != null 
          ? (json['late_fee_per_hour'] as num).toDouble() 
          : null,
      discounts: json['discounts'] as String?,
      images: json['images'] != null 
          ? List<String>.from(json['images'] as List) 
          : null,
      video: json['video'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      currentOdometerReading: json['current_odometer_reading'] != null 
          ? (json['current_odometer_reading'] as num).toDouble() 
          : null,
      lastServiceDate: json['last_service_date'] as String?,
      nextServiceDue: json['next_service_due'] as String?,
      damagesOrIssues: json['damages_or_issues'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'make': make,
      'model': model,
      'year': year,
      'variant': variant,
      'fuel_type': fuelType.toString().split('.').last.toUpperCase(),
      'transmission': transmission.toString().split('.').last.toUpperCase(),
      'body_type': bodyType.toString().split('.').last.toUpperCase(),
      'color': color,
      'seating_capacity': seatingCapacity,
      'vehicle_number': vehicleNumber,
      'registration_state': registrationState,
      'owner_id': ownerId,
    };
    
    // Only include optional fields if they are not null
    if (currentLocation != null) data['current_location'] = currentLocation;
    if (availableBranches != null) data['available_branches'] = availableBranches;
    if (rentalPricePerDay != null) data['rental_price_per_day'] = rentalPricePerDay;
    if (rentalPricePerHour != null) data['rental_price_per_hour'] = rentalPricePerHour;
    if (minimumRentDuration != null) data['minimum_rent_duration'] = minimumRentDuration;
    if (maximumRentDuration != null) data['maximum_rent_duration'] = maximumRentDuration;
    if (securityDeposit != null) data['security_deposit'] = securityDeposit;
    if (lateFeePerHour != null) data['late_fee_per_hour'] = lateFeePerHour;
    if (discounts != null) data['discounts'] = discounts;
    if (images != null) data['images'] = images;
    if (video != null) data['video'] = video;
    data['is_available'] = isAvailable;
    if (currentOdometerReading != null) data['current_odometer_reading'] = currentOdometerReading;
    if (lastServiceDate != null) data['last_service_date'] = lastServiceDate;
    if (nextServiceDue != null) data['next_service_date'] = nextServiceDue;
    if (damagesOrIssues != null) data['damages_or_issues'] = damagesOrIssues;
    
    return data;
  }

  static FuelType _parseFuelType(String value) {
    switch (value.toLowerCase()) {
      case 'petrol': return FuelType.petrol;
      case 'diesel': return FuelType.diesel;
      case 'electric': return FuelType.electric;
      case 'hybrid': return FuelType.hybrid;
      default: return FuelType.petrol;
    }
  }
  
  static TransmissionType _parseTransmission(String value) {
    switch (value.toLowerCase()) {
      case 'manual': return TransmissionType.manual;
      case 'automatic': return TransmissionType.automatic;
      case 'cvt': return TransmissionType.cvt;
      default: return TransmissionType.manual;
    }
  }
  
  static BodyType _parseBodyType(String value) {
    switch (value.toLowerCase()) {
      case 'sedan': return BodyType.sedan;
      case 'suv': return BodyType.suv;
      case 'hatchback': return BodyType.hatchback;
      case 'coupe': return BodyType.coupe;
      case 'van': return BodyType.van;
      case 'truck': return BodyType.truck;
      default: return BodyType.sedan;
    }
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
    registrationState,
    ownerId,
    ownerName,
    ownerContact,
    currentLocation,
    availableBranches,
    rentalPricePerDay,
    rentalPricePerHour,
    minimumRentDuration,
    maximumRentDuration,
    securityDeposit,
    lateFeePerHour,
    discounts,
    images,
    video,
    isAvailable,
    currentOdometerReading,
    lastServiceDate,
    nextServiceDue,
    damagesOrIssues,
    createdAt,
    updatedAt,
  ];
}