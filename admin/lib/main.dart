import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/cars/bloc/car_bloc.dart';
import 'features/bookings/bloc/booking_bloc.dart';
import 'features/owners/bloc/owner_bloc.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.getIt<AuthBloc>(),
        ),
        BlocProvider<CarBloc>(
          create: (_) => di.getIt<CarBloc>(),
        ),
        BlocProvider<BookingBloc>(
          create: (_) => di.getIt<BookingBloc>(),
        ),
        BlocProvider<OwnerBloc>(
          create: (_) => di.getIt<OwnerBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Car Rental Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when the widget is first built
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (state is Authenticated) {
          return const DashboardScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}
