import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookings extends BookingEvent {
  const LoadBookings();
}

class RefreshBookings extends BookingEvent {
  const RefreshBookings();
}

class LoadMoreBookings extends BookingEvent {
  final int page;
  
  const LoadMoreBookings(this.page);
  
  @override
  List<Object?> get props => [page];
}

class LoadBookingDetails extends BookingEvent {
  final String bookingId;
  
  const LoadBookingDetails(this.bookingId);
  
  @override
  List<Object?> get props => [bookingId];
}

class LoadUserBookings extends BookingEvent {
  final String userId;
  
  const LoadUserBookings(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class CreateBooking extends BookingEvent {
  final Map<String, dynamic> bookingData;
  
  const CreateBooking(this.bookingData);
  
  @override
  List<Object?> get props => [bookingData];
}

class CancelBooking extends BookingEvent {
  final String bookingId;
  
  const CancelBooking(this.bookingId);
  
  @override
  List<Object?> get props => [bookingId];
} 