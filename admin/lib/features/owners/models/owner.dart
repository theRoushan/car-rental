import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  final String id;
  final String name;
  final String contactInfo;
  final String createdAt;
  final String updatedAt;

  const Owner({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as String,
      name: json['name'] as String,
      contactInfo: json['contact_info'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact_info': contactInfo,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    contactInfo,
    createdAt,
    updatedAt,
  ];
} 