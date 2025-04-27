import 'package:car_rental_admin/features/cars/repositories/car_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/car.dart';
import 'car_event.dart';
import 'car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final CarRepository carRepository;

  CarBloc({required this.carRepository}) : super(CarLoading()) {
    on<LoadCars>((event, emit) async {
      try {
        final response = await carRepository.getCars(page: event.page, limit: event.limit);
        final cars = response.items;
        final hasNextPage = response.pagination.hasNext;
        emit(CarsLoaded(cars: cars, hasNextPage: hasNextPage));
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });
  }
}