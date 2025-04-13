import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/cars/bloc/car_bloc.dart';
import '../../features/cars/repositories/car_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Dio
  getIt.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'YOUR_API_BASE_URL', // Replace with your actual API base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    return dio;
  });

  // Repositories
  getIt.registerLazySingleton(
    () => CarRepository(
      dio: getIt(),
      baseUrl: 'YOUR_API_BASE_URL', // Replace with your actual API base URL
    ),
  );

  // Blocs
  getIt.registerFactory(
    () => AuthBloc(prefs: getIt()),
  );

  getIt.registerFactory(
    () => CarBloc(carRepository: getIt()),
  );
} 