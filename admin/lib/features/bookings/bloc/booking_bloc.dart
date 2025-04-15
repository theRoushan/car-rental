import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc(this._bookingRepository) : super(const BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<LoadBookingDetails>(_onLoadBookingDetails);
    on<LoadUserBookings>(_onLoadUserBookings);
    on<CreateBooking>(_onCreateBooking);
    on<CancelBooking>(_onCancelBooking);
  }

  Future<void> _onLoadBookings(
    LoadBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await _bookingRepository.getBookings();
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoadBookingDetails(
    LoadBookingDetails event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await _bookingRepository.getBooking(event.bookingId);
      if (booking != null) {
        emit(BookingDetailsLoaded(booking));
      } else {
        emit(const BookingError('Booking not found'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoadUserBookings(
    LoadUserBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await _bookingRepository.getUserBookings(event.userId);
      emit(UserBookingsLoaded(bookings, event.userId));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await _bookingRepository.createBooking(event.bookingData);
      if (booking != null) {
        emit(BookingCreated(booking));
      } else {
        emit(const BookingError('Failed to create booking'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await _bookingRepository.cancelBooking(event.bookingId);
      if (booking != null) {
        emit(BookingCancelled(event.bookingId));
      } else {
        emit(const BookingError('Failed to cancel booking'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
} 