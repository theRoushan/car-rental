import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../models/booking.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const LoadBookings());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottomReached && !_isLoadingMore) {
      final currentState = context.read<BookingBloc>().state;
      if (currentState is BookingsLoaded && !currentState.hasReachedMax) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<BookingBloc>().add(LoadMoreBookings(currentState.currentPage + 1));
      }
    }
  }

  bool get _isBottomReached {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    context.read<BookingBloc>().add(const RefreshBookings());
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingsLoaded) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      },
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is BookingError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        
        if (state is BookingsLoaded) {
          return _buildRefreshableBookingList(state.bookings);
        }

        if (state is PaginationLoading) {
          return _buildRefreshableBookingList(state.currentBookings, isLoadingMore: true);
        }
        
        return const Center(child: Text('No bookings data'));
      },
    );
  }

  Widget _buildRefreshableBookingList(List<Booking> bookings, {bool isLoadingMore = false}) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: bookings.isEmpty
          ? const Center(child: Text('No bookings available'))
          : _buildBookingList(bookings, isLoadingMore: isLoadingMore),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, {bool isLoadingMore = false}) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: isLoadingMore ? bookings.length + 1 : bookings.length,
      itemBuilder: (context, index) {
        if (index >= bookings.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Booking #${booking.id.substring(0, 8)}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Car ID: ${booking.carId.substring(0, 8)}'),
                Text('Start: ${_formatDateTime(booking.startTime)}'),
                Text('End: ${_formatDateTime(booking.endTime)}'),
                Text('Status: ${booking.status.toString().split('.').last.toUpperCase()}'),
              ],
            ),
            trailing: Text(
              '₹${booking.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            isThreeLine: true,
            onTap: () {
              // TODO: Navigate to booking details screen
            },
          ),
        );
      },
    );
  }
  
  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }
}