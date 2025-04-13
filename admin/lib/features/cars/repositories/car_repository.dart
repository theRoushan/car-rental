import 'package:dio/dio.dart';
import '../models/car.dart';

class CarRepository {
  final Dio _dio;
  final String _baseUrl;

  CarRepository({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  Future<List<Car>> getCars() async {
    try {
      final response = await _dio.get('$_baseUrl/cars');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Car.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch cars: ${e.toString()}');
    }
  }

  Future<Car> getCar(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/cars/$id');
      return Car.fromJson(response.data['data']);
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
      return Car.fromJson(response.data['data']);
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
      return Car.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update car: ${e.toString()}');
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      await _dio.delete('$_baseUrl/cars/$id');
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
      return Car.fromJson(response.data['data']);
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
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Car.fromJson(json)).toList();
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
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Car.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to filter cars: ${e.toString()}');
    }
  }
} 