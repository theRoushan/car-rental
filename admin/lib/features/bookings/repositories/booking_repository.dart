import 'package:car_rental_admin/features/cars/models/paginated_car_list.dart';

import '../../../core/services/api_service.dart';
import '../models/booking.dart';

class BookingRepository {
  final ApiService _apiService;

  BookingRepository(this._apiService);

  Future<PaginatedList<Booking>> getBookings({int page = 1, int limit = 10}) async {
    // final response = await _apiService.get<List<Booking>>(
    //   '/api/bookings',
    //   queryParameters: {
    //     'page': page.toString(),
    //     'limit': limit.toString(),
    //   },
    //   fromJson: (json) => json,
    // );
    // return response.data ?? [];

    try{
      final queryParams = {
        'page': page,
        'limit': limit,
      };

      final apiResponse = await _apiService.get(
        '/api/bookings',
        queryParameters: queryParams,
        fromJson: (json) => json,
      );
      

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to fetch bookings');
      }

      if (apiResponse.data == null) {
        throw Exception('No data returned');
      }

      return PaginatedList<Booking>.fromJson(
        apiResponse.data!,
        (item) => Booking.fromJson(item),
      );

    } catch (e) {
      throw Exception('Failed to fetch bookings: ${e.toString()}');

    }
  }

  Future<Booking?> getBooking(String id) async {
    final response = await _apiService.get<Booking>(
      '/api/bookings/$id',
      fromJson: (json) => Booking.fromJson(json['data']),
    );
    return response.data;
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final response = await _apiService.get<List<Booking>>(
      '/api/users/$userId/bookings',
      fromJson: (json) => (json['data'] as List)
          .map((item) => Booking.fromJson(item))
          .toList(),
    );
    return response.data ?? [];
  }

  Future<Booking?> createBooking(Map<String, dynamic> bookingData) async {
    final response = await _apiService.post<Booking>(
      '/api/bookings',
      data: bookingData,
      fromJson: (json) => Booking.fromJson(json['data']),
    );
    return response.data;
  }

  Future<Booking?> cancelBooking(String id) async {
    final response = await _apiService.delete<Booking>(
      '/api/bookings/$id',
      fromJson: (json) => Booking.fromJson(json['data']),
    );
    return response.data;
  }
} 