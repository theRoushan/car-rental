import 'package:car_rental_admin/core/iconmoon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cars/bloc/car_bloc.dart';
import '../../cars/bloc/car_event.dart';
import '../../cars/screens/car_list_screen.dart';
import '../../bookings/bloc/booking_bloc.dart';
import '../../bookings/bloc/booking_event.dart';
import '../../bookings/screens/booking_list_screen.dart';
import '../../owners/bloc/owner_bloc.dart';
import '../../owners/bloc/owner_event.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<CarBloc>().add(LoadCars());
    context.read<BookingBloc>().add(const LoadBookings());
    context.read<OwnerBloc>().add(const LoadOwners());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            CarListScreen(),
            BookingListScreen(),
            // OwnerListScreen(),
            Center(child: Text('Settings')),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        shadowColor: Colors.transparent,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        labelTextStyle: WidgetStateProperty.fromMap(
          {
            WidgetState.selected:  const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            WidgetState.any:   TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],

            ),
          },
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icomoon.carRear, size: 20),
            label: 'Cars',
          ),
          NavigationDestination(
            icon: Icon(Icomoon.booking, size: 20),
            label: 'Bookings',
          ),
          // NavigationDestination(
          //   icon: Icon(Icomoon.holdingHandKey, size: 20),
          //   label: 'Owners',
          // ),
          NavigationDestination(
            icon: Icon(Icomoon.settings, size: 20),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 