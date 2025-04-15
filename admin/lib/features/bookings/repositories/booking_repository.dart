import '../../../core/services/api_service.dart';
import '../models/booking.dart';

class BookingRepository {
  final ApiService _apiService;

  BookingRepository(this._apiService);

  Future<List<Booking>> getBookings() async {
    final response = await _apiService.get<List<Booking>>(
      '/api/bookings',
      fromJson: (json) => (json['data'] as List)
          .map((item) => Booking.fromJson(item))
          .toList(),
    );
    return response.data ?? [];
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