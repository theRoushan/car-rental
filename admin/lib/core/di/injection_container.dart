import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../services/api_service.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/cars/bloc/car_bloc.dart';
import '../../features/cars/repositories/car_repository.dart';

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
} 