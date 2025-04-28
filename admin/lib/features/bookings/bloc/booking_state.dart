import 'package:equatable/equatable.dart';

import '../models/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class PaginationLoading extends BookingState {
  final List<Booking> currentBookings;
  
  const PaginationLoading(this.currentBookings);
  
  @override
  List<Object?> get props => [currentBookings];
}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;
  final bool hasReachedMax;
  final int currentPage;

  const BookingsLoaded({
    required this.bookings,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  BookingsLoaded copyWith({
    List<Booking>? bookings,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return BookingsLoaded(
      bookings: bookings ?? this.bookings,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [bookings, hasReachedMax, currentPage];
}

class BookingDetailsLoaded extends BookingState {
  final Booking booking;

  const BookingDetailsLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

class UserBookingsLoaded extends BookingState {
  final List<Booking> bookings;
  final String userId;

  const UserBookingsLoaded(this.bookings, this.userId);

  @override
  List<Object?> get props => [bookings, userId];
}

class BookingCreated extends BookingState {
  final Booking booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCancelled extends BookingState {
  final String bookingId;

  const BookingCancelled(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
} 