import 'dart:convert';
import 'package:car_rental_admin/core/config/api_config.dart';
import 'package:car_rental_admin/features/cars/models/car_creation_session.dart';
import 'package:http/http.dart' as http;

class CarCreationRepository {
  final http.Client _client;
  final String _baseUrl = ApiConfig.baseUrl;

  CarCreationRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<CarCreationSession> initiateCarCreation() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/init'),
    );

    if (response.statusCode == 200) {
      return CarCreationSession.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to initiate car creation');
    }
  }

  Future<StepResponse> saveBasicDetails(String sessionId, BasicDetailsStep details) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/basic-details'),
      body: json.encode(details.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save basic details');
    }
  }

  Future<StepResponse> saveOwnerInfo(String sessionId, OwnerInfoStep ownerInfo) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/owner-info'),
      body: json.encode(ownerInfo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save owner information');
    }
  }

  Future<StepResponse> saveLocationDetails(String sessionId, LocationDetailsStep location) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/location-details'),
      body: json.encode(location.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save location details');
    }
  }

  Future<StepResponse> saveRentalInfo(String sessionId, RentalInfoStep rentalInfo) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/rental-info'),
      body: json.encode(rentalInfo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save rental information');
    }
  }

  Future<StepResponse> saveDocumentsMedia(String sessionId, DocumentsMediaStep docsMedia) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/documents-media'),
      body: json.encode(docsMedia.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save documents and media');
    }
  }

  Future<StepResponse> saveStatusInfo(String sessionId, StatusInfoStep status) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/status-info'),
      body: json.encode(status.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save status information');
    }
  }

  Future<StepResponse> getCarCreationProgress(String sessionId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/v1/cars/create/$sessionId/progress'),
    );

    if (response.statusCode == 200) {
      return StepResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get car creation progress');
    }
  }
} 