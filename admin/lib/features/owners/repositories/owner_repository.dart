import '../../../core/services/api_service.dart';
import '../models/owner.dart';

class OwnerRepository {
  final ApiService _apiService;

  OwnerRepository(this._apiService);

  Future<List<Owner>> getOwners() async {
    final response = await _apiService.get<List<Owner>>(
      '/api/owners',
      fromJson: (json) => (json['data'] as List)
          .map((item) => Owner.fromJson(item))
          .toList(),
    );
    return response.data ?? [];
  }

  Future<Owner?> getOwner(String id) async {
    final response = await _apiService.get<Owner>(
      '/api/owners/$id',
      fromJson: (json) => Owner.fromJson(json['data']),
    );
    return response.data;
  }

  Future<Owner?> createOwner(Map<String, dynamic> ownerData) async {
    final response = await _apiService.post<Owner>(
      '/api/owners',
      data: ownerData,
      fromJson: (json) => Owner.fromJson(json['data']),
    );
    return response.data;
  }

  Future<Owner?> updateOwner(String id, Map<String, dynamic> ownerData) async {
    final response = await _apiService.put<Owner>(
      '/api/owners/$id',
      data: ownerData,
      fromJson: (json) => Owner.fromJson(json['data']),
    );
    return response.data;
  }

  Future<Owner?> deleteOwner(String id) async {
    final response = await _apiService.delete<Owner>(
      '/api/owners/$id',
      fromJson: (json) => Owner.fromJson(json['data']),
    );
    return response.data;
  }
} 