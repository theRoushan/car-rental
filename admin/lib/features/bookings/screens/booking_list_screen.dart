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
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const LoadBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is BookingError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          
          if (state is BookingsLoaded) {
            return _buildBookingList(state.bookings);
          }
          
          return const Center(child: Text('No bookings data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create booking screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings available'));
    }
    
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
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