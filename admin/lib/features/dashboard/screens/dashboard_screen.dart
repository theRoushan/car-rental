import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            icon: Icon(FluentIcons.vehicle_car_32_regular),
            label: 'Cars',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.calendarCheck),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Owners',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.spaghettiMonsterFlying),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 