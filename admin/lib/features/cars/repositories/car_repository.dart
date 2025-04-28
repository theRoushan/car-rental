import 'package:dio/dio.dart';
import '../models/car.dart';
import '../models/paginated_car_list.dart';
import '../../../core/models/api_response.dart';

class CarRepository {
  final Dio _dio;
  final String _baseUrl;

  CarRepository({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  Future<PaginatedList> getCars({
    int page = 1, 
    int limit = 10,
    String? vehicleNumber,
  }) async {
    try {
      final queryParams = {
        'page': page, 
        'limit': limit,
        if (vehicleNumber != null && vehicleNumber.isNotEmpty) 
          'vehicle_number': vehicleNumber,
      };
      
      final response = await _dio.get(
        '$_baseUrl/api/cars',
        queryParameters: queryParams,
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to fetch cars');
      }
      if (apiResponse.data == null) {
        throw Exception('No data returned');
      }

      return PaginatedList.fromJson(apiResponse.data!, 
        (item) => Car.fromJson(item),
      );
    } catch (e) {
      throw Exception('Failed to fetch cars: ${e.toString()}');
    }
  }

  Future<Car> getCar(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/cars/$id');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to fetch car');
      }
      
      if (apiResponse.data == null) {
        throw Exception('Car not found');
      }
      
      return Car.fromJson(apiResponse.data!);
    } catch (e) {
      throw Exception('Failed to fetch car: ${e.toString()}');
    }
  }

  Future<Car> createCar(Car car) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/cars',
        data: car.toJson(),
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json ,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create car');
      }
      
      if (apiResponse.data == null) {
        throw Exception('Failed to create car: No data returned');
      }
      
      return Car.fromJson(apiResponse.data!);
    } catch (e) {
      throw Exception('Failed to create car: ${e.toString()}');
    }
  }

  Future<Car> updateCar(Car car) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/cars/${car.id}',
        data: car.toJson(),
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update car');
      }
      
      if (apiResponse.data == null) {
        throw Exception('Failed to update car: No data returned');
      }
      
      return Car.fromJson(apiResponse.data!);
    } catch (e) {
      throw Exception('Failed to update car: ${e.toString()}');
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/cars/$id');
      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete car');
      }
    } catch (e) {
      throw Exception('Failed to delete car: ${e.toString()}');
    }
  }

  Future<Car> toggleCarAvailability(String id, bool isAvailable) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/cars/$id/availability',
        data: {'isAvailable': isAvailable},
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json ,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to toggle car availability');
      }
      
      if (apiResponse.data == null) {
        throw Exception('Failed to toggle car availability: No data returned');
      }
      
      return Car.fromJson(apiResponse.data!);
    } catch (e) {
      throw Exception('Failed to toggle car availability: ${e.toString()}');
    }
  }

  Future<List<Car>> searchCars(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/cars/search',
        queryParameters: {'q': query},
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to search cars');
      }
      
      if (apiResponse.data == null) {
        return [];
      }
      
      final carsData = apiResponse.data!['cars'] as List<dynamic>;
      return carsData.map((item) => Car.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to search cars: ${e.toString()}');
    }
  }

  Future<List<Car>> filterCars({
    String? brand,
    String? model,
    String? year,
    bool? isAvailable,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/cars/filter',
        queryParameters: {
          if (brand != null) 'brand': brand,
          if (model != null) 'model': model,
          if (year != null) 'year': year,
          if (isAvailable != null) 'isAvailable': isAvailable,
          if (minPrice != null) 'minPrice': minPrice,
          if (maxPrice != null) 'maxPrice': maxPrice,
        },
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json ,
      );
      
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to filter cars');
      }
      
      if (apiResponse.data == null) {
        return [];
      }
      
      final carsData = apiResponse.data!['cars'] as List<dynamic>;
      return carsData.map((item) => Car.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to filter cars: ${e.toString()}');
    }
  }
}