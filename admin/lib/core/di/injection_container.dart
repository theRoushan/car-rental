import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../services/api_service.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/cars/bloc/car_bloc.dart';
import '../../features/cars/repositories/car_repository.dart';
import '../../features/bookings/repositories/booking_repository.dart';
import '../../features/bookings/bloc/booking_bloc.dart';
import '../../features/owners/repositories/owner_repository.dart';
import '../../features/owners/bloc/owner_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Services
  getIt.registerLazySingleton(
    () => ApiService(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton(
    () => CarRepository(
      dio: getIt<ApiService>().dio,
      baseUrl: ApiService.baseUrl,
    ),
  );
  
  getIt.registerLazySingleton(
    () => BookingRepository(getIt()),
  );
  
  getIt.registerLazySingleton(
    () => OwnerRepository(getIt()),
  );

  // Blocs
  getIt.registerFactory(
    () => AuthBloc(
      prefs: getIt(),
      apiService: getIt(),
    ),
  );

  getIt.registerFactory(
    () => CarBloc(carRepository: getIt()),
  );
  
  getIt.registerFactory(
    () => BookingBloc(getIt()),
  );
  
  getIt.registerFactory(
    () => OwnerBloc(getIt()),
  );
} 