import 'package:car_rental_admin/features/cars/models/car.dart';
import 'package:equatable/equatable.dart';

class CarCreationSession extends Equatable {
  final String id;
  final BasicDetailsStep basicDetails;
  final OwnerInfoStep ownerInfo;
  final LocationDetailsStep locationDetails;
  final RentalInfoStep rentalInfo;
  final DocumentsMediaStep documentsMedia;
  final StatusInfoStep statusInfo;
  final bool isComplete;

  const CarCreationSession({
    required this.id,
    this.basicDetails = const BasicDetailsStep(),
    this.ownerInfo = const OwnerInfoStep(),
    this.locationDetails = const LocationDetailsStep(),
    this.rentalInfo = const RentalInfoStep(),
    this.documentsMedia = const DocumentsMediaStep(),
    this.statusInfo = const StatusInfoStep(),
    this.isComplete = false,
  });

  CarCreationSession copyWith({
    String? id,
    BasicDetailsStep? basicDetails,
    OwnerInfoStep? ownerInfo,
    LocationDetailsStep? locationDetails,
    RentalInfoStep? rentalInfo,
    DocumentsMediaStep? documentsMedia,
    StatusInfoStep? statusInfo,
    bool? isComplete,
  }) {
    return CarCreationSession(
      id: id ?? this.id,
      basicDetails: basicDetails ?? this.basicDetails,
      ownerInfo: ownerInfo ?? this.ownerInfo,
      locationDetails: locationDetails ?? this.locationDetails,
      rentalInfo: rentalInfo ?? this.rentalInfo,
      documentsMedia: documentsMedia ?? this.documentsMedia,
      statusInfo: statusInfo ?? this.statusInfo,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [
        id,
        basicDetails,
        ownerInfo,
        locationDetails,
        rentalInfo,
        documentsMedia,
        statusInfo,
        isComplete,
      ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'basic_details': basicDetails.toJson(),
    'owner_info': ownerInfo.toJson(),
    'location_details': locationDetails.toJson(),
    'rental_info': rentalInfo.toJson(),
    'documents_media': documentsMedia.toJson(),
    'status_info': statusInfo.toJson(),
    'is_complete': isComplete,
  };

  factory CarCreationSession.fromJson(Map<String, dynamic> json) => CarCreationSession(
    id: json['id'],
    basicDetails: BasicDetailsStep.fromJson(json['basic_details']),
    ownerInfo: OwnerInfoStep.fromJson(json['owner_info']),
    locationDetails: LocationDetailsStep.fromJson(json['location_details']),
    rentalInfo: RentalInfoStep.fromJson(json['rental_info']),
    documentsMedia: DocumentsMediaStep.fromJson(json['documents_media']),
    statusInfo: StatusInfoStep.fromJson(json['status_info']),
    isComplete: json['is_complete'],
  );
}

class BasicDetailsStep extends Equatable {
  final String? make;
  final String? model;
  final int? year;
  final String? variant;
  final FuelType? fuelType;
  final TransmissionType? transmission;
  final BodyType? bodyType;
  final String? color;
  final int? seatingCapacity;

  const BasicDetailsStep({
    this.make,
    this.model,
    this.year,
    this.variant,
    this.fuelType,
    this.transmission,
    this.bodyType,
    this.color,
    this.seatingCapacity,
  });

  bool get isComplete =>
      make != null &&
      model != null &&
      year != null &&
      fuelType != null &&
      transmission != null &&
      bodyType != null &&
      color != null &&
      seatingCapacity != null;

  BasicDetailsStep copyWith({
    String? make,
    String? model,
    int? year,
    String? variant,
    FuelType? fuelType,
    TransmissionType? transmission,
    BodyType? bodyType,
    String? color,
    int? seatingCapacity,
  }) {
    return BasicDetailsStep(
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      variant: variant ?? this.variant,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      bodyType: bodyType ?? this.bodyType,
      color: color ?? this.color,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
    );
  }

  @override
  List<Object?> get props => [
        make,
        model,
        year,
        variant,
        fuelType,
        transmission,
        bodyType,
        color,
        seatingCapacity,
      ];

  Map<String, dynamic> toJson() => {
    'make': make,
    'model': model,
    'year': year,
    'variant': variant,
    'fuel_type': fuelType?.toString().split('.').last,
    'transmission': transmission?.toString().split('.').last,
    'body_type': bodyType?.toString().split('.').last,
    'color': color,
    'seating_capacity': seatingCapacity,
  };

  factory BasicDetailsStep.fromJson(Map<String, dynamic> json) => BasicDetailsStep(
    make: json['make'],
    model: json['model'],
    year: json['year'],
    variant: json['variant'],
    fuelType: json['fuel_type'] != null ? FuelType.values.firstWhere(
      (e) => e.toString().split('.').last == json['fuel_type']
    ) : null,
    transmission: json['transmission'] != null ? TransmissionType.values.firstWhere(
      (e) => e.toString().split('.').last == json['transmission']
    ) : null,
    bodyType: json['body_type'] != null ? BodyType.values.firstWhere(
      (e) => e.toString().split('.').last == json['body_type']
    ) : null,
    color: json['color'],
    seatingCapacity: json['seating_capacity'],
  );
}

class OwnerInfoStep extends Equatable {
  final String? ownerName;
  final String? contactNumber;
  final String? email;
  final String? address;

  const OwnerInfoStep({
    this.ownerName,
    this.contactNumber,
    this.email,
    this.address,
  });

  bool get isComplete =>
      ownerName != null &&
      contactNumber != null &&
      email != null &&
      address != null;

  OwnerInfoStep copyWith({
    String? ownerName,
    String? contactNumber,
    String? email,
    String? address,
  }) {
    return OwnerInfoStep(
      ownerName: ownerName ?? this.ownerName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [ownerName, contactNumber, email, address];

  Map<String, dynamic> toJson() => {
    'owner_name': ownerName,
    'contact_number': contactNumber,
    'email': email,
    'address': address,
  };

  factory OwnerInfoStep.fromJson(Map<String, dynamic> json) => OwnerInfoStep(
    ownerName: json['owner_name'],
    contactNumber: json['contact_number'],
    email: json['email'],
    address: json['address'],
  );
}

class LocationDetailsStep extends Equatable {
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  const LocationDetailsStep({
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  bool get isComplete =>
      address != null &&
      city != null &&
      state != null &&
      country != null &&
      zipCode != null;

  LocationDetailsStep copyWith({
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) {
    return LocationDetailsStep(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  @override
  List<Object?> get props => [address, city, state, country, zipCode];

  Map<String, dynamic> toJson() => {
    'address': address,
    'city': city,
    'state': state,
    'country': country,
    'zip_code': zipCode,
  };

  factory LocationDetailsStep.fromJson(Map<String, dynamic> json) => LocationDetailsStep(
    address: json['address'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
    zipCode: json['zip_code'],
  );
}

class RentalInfoStep extends Equatable {
  final double? dailyRate;
  final double? weeklyRate;
  final double? monthlyRate;
  final double? securityDeposit;
  final int? minimumRentalDays;

  const RentalInfoStep({
    this.dailyRate,
    this.weeklyRate,
    this.monthlyRate,
    this.securityDeposit,
    this.minimumRentalDays,
  });

  bool get isComplete =>
      dailyRate != null &&
      weeklyRate != null &&
      monthlyRate != null &&
      securityDeposit != null &&
      minimumRentalDays != null;

  RentalInfoStep copyWith({
    double? dailyRate,
    double? weeklyRate,
    double? monthlyRate,
    double? securityDeposit,
    int? minimumRentalDays,
  }) {
    return RentalInfoStep(
      dailyRate: dailyRate ?? this.dailyRate,
      weeklyRate: weeklyRate ?? this.weeklyRate,
      monthlyRate: monthlyRate ?? this.monthlyRate,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      minimumRentalDays: minimumRentalDays ?? this.minimumRentalDays,
    );
  }

  @override
  List<Object?> get props => [
        dailyRate,
        weeklyRate,
        monthlyRate,
        securityDeposit,
        minimumRentalDays,
      ];

  Map<String, dynamic> toJson() => {
    'daily_rate': dailyRate,
    'weekly_rate': weeklyRate,
    'monthly_rate': monthlyRate,
    'security_deposit': securityDeposit,
    'minimum_rental_days': minimumRentalDays,
  };

  factory RentalInfoStep.fromJson(Map<String, dynamic> json) => RentalInfoStep(
    dailyRate: json['daily_rate']?.toDouble(),
    weeklyRate: json['weekly_rate']?.toDouble(),
    monthlyRate: json['monthly_rate']?.toDouble(),
    securityDeposit: json['security_deposit']?.toDouble(),
    minimumRentalDays: json['minimum_rental_days'],
  );
}

class DocumentsMediaStep extends Equatable {
  final List<String> documentUrls;
  final List<String> imageUrls;
  final List<String> videoUrls;

  const DocumentsMediaStep({
    this.documentUrls = const [],
    this.imageUrls = const [],
    this.videoUrls = const [],
  });

  bool get isComplete =>
      documentUrls.isNotEmpty && imageUrls.isNotEmpty;

  DocumentsMediaStep copyWith({
    List<String>? documentUrls,
    List<String>? imageUrls,
    List<String>? videoUrls,
  }) {
    return DocumentsMediaStep(
      documentUrls: documentUrls ?? this.documentUrls,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrls: videoUrls ?? this.videoUrls,
    );
  }

  @override
  List<Object?> get props => [documentUrls, imageUrls, videoUrls];

  Map<String, dynamic> toJson() => {
    'document_urls': documentUrls,
    'image_urls': imageUrls,
    'video_urls': videoUrls,
  };

  factory DocumentsMediaStep.fromJson(Map<String, dynamic> json) => DocumentsMediaStep(
    documentUrls: List<String>.from(json['document_urls'] ?? []),
    imageUrls: List<String>.from(json['image_urls'] ?? []),
    videoUrls: List<String>.from(json['video_urls'] ?? []),
  );
}

class StatusInfoStep extends Equatable {
  final bool? isAvailable;
  final DateTime? lastMaintenanceDate;
  final DateTime? nextMaintenanceDue;
  final String? maintenanceNotes;

  const StatusInfoStep({
    this.isAvailable,
    this.lastMaintenanceDate,
    this.nextMaintenanceDue,
    this.maintenanceNotes,
  });

  bool get isComplete =>
      isAvailable != null &&
      lastMaintenanceDate != null &&
      nextMaintenanceDue != null;

  StatusInfoStep copyWith({
    bool? isAvailable,
    DateTime? lastMaintenanceDate,
    DateTime? nextMaintenanceDue,
    String? maintenanceNotes,
  }) {
    return StatusInfoStep(
      isAvailable: isAvailable ?? this.isAvailable,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      nextMaintenanceDue: nextMaintenanceDue ?? this.nextMaintenanceDue,
      maintenanceNotes: maintenanceNotes ?? this.maintenanceNotes,
    );
  }

  @override
  List<Object?> get props => [
        isAvailable,
        lastMaintenanceDate,
        nextMaintenanceDue,
        maintenanceNotes,
      ];

  Map<String, dynamic> toJson() => {
    'is_available': isAvailable,
    'last_maintenance_date': lastMaintenanceDate?.toIso8601String(),
    'next_maintenance_due': nextMaintenanceDue?.toIso8601String(),
    'maintenance_notes': maintenanceNotes,
  };

  factory StatusInfoStep.fromJson(Map<String, dynamic> json) => StatusInfoStep(
    isAvailable: json['is_available'],
    lastMaintenanceDate: json['last_maintenance_date'] != null 
      ? DateTime.parse(json['last_maintenance_date'])
      : null,
    nextMaintenanceDue: json['next_maintenance_due'] != null
      ? DateTime.parse(json['next_maintenance_due'])
      : null,
    maintenanceNotes: json['maintenance_notes'],
  );
}

enum CreationStep {
  basicDetails,
  ownerInfo,
  locationDetails,
  rentalInfo,
  documentsMedia,
  statusInfo,
  complete
}

class StepResponse {
  final String sessionId;
  final String carId;
  final CreationStep currentStep;
  final CreationStep nextStep;
  final String message;

  StepResponse({
    required this.sessionId,
    required this.carId,
    required this.currentStep,
    required this.nextStep,
    required this.message,
  });

  factory StepResponse.fromJson(Map<String, dynamic> json) {
    return StepResponse(
      sessionId: json['session_id'],
      carId: json['car_id'],
      currentStep: CreationStep.values.firstWhere(
        (e) => e.toString().split('.').last == json['current_step'],
      ),
      nextStep: CreationStep.values.firstWhere(
        (e) => e.toString().split('.').last == json['next_step'],
      ),
      message: json['message'],
    );
  }
} 