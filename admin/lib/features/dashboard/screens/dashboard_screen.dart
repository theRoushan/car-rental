import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../cars/bloc/car_bloc.dart';
import '../../cars/bloc/car_event.dart';
import '../../cars/screens/car_list_screen.dart';
import '../../bookings/bloc/booking_bloc.dart';
import '../../bookings/bloc/booking_event.dart';
import '../../bookings/screens/booking_list_screen.dart';
import '../../owners/bloc/owner_bloc.dart';
import '../../owners/bloc/owner_event.dart';
import '../../owners/screens/owner_list_screen.dart';

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
      appBar: AppBar(
        title: const Text('Car Rental Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          CarListScreen(),
          BookingListScreen(),
          OwnerListScreen(),
          Center(child: Text('Settings')),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Owners',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 