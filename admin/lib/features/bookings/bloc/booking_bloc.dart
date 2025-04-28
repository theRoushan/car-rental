import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;
  static const int _pageSize = 10;

  BookingBloc(this._bookingRepository) : super(const BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<RefreshBookings>(_onRefreshBookings);
    on<LoadMoreBookings>(_onLoadMoreBookings);
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
      final bookings = await _bookingRepository.getBookings(page: 1, limit: _pageSize);
      final hasReachedMax = bookings.items.length < _pageSize;
      emit(BookingsLoaded(
        bookings: bookings.items,
        hasReachedMax: hasReachedMax,
        currentPage: 1,
      ));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onRefreshBookings(
    RefreshBookings event,
    Emitter<BookingState> emit,
  ) async {
    try {
      final bookings = await _bookingRepository.getBookings(page: 1, limit: _pageSize);
      final hasReachedMax = bookings.items.length < _pageSize;
      emit(BookingsLoaded(
        bookings: bookings.items,
        hasReachedMax: hasReachedMax,
        currentPage: 1,
      ));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoadMoreBookings(
    LoadMoreBookings event,
    Emitter<BookingState> emit,
  ) async {
    final currentState = state;
    if (currentState is BookingsLoaded) {
      if (currentState.hasReachedMax) return;
      
      emit(PaginationLoading(currentState.bookings));
      
      try {
        final newBookings = await _bookingRepository.getBookings(
          page: event.page,
          limit: _pageSize,
        );
        
        final hasReachedMax = newBookings.items.length < _pageSize;
        
        emit(currentState.copyWith(
          bookings: [...currentState.bookings, ...newBookings.items],
          hasReachedMax: hasReachedMax,
          currentPage: event.page,
        ));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
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