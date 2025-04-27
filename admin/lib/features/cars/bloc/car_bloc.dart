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
        emit(CarLoading());
        final response = await carRepository.getCars(page: event.page, limit: event.limit);
        final cars = response.items;
        final pagination = response.pagination;
        emit(CarsLoaded(
          cars: cars, 
          hasNextPage: pagination.hasNext,
          currentPage: pagination.currentPage,
          totalPages: pagination.totalPages,
        ));
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });

    on<LoadMoreCars>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is CarsLoaded) {
          if (!currentState.hasNextPage || currentState.isLoadingMore) {
            return;
          }
          
          // Emit current state with loading flag
          emit(currentState.copyWith(isLoadingMore: true));
          
          final nextPage = currentState.currentPage + 1;
          final response = await carRepository.getCars(page: nextPage, limit: event.limit);
          
          // Combine previous cars with new cars
          final updatedCars = List<Car>.from(currentState.cars)..addAll(response.items);
          
          emit(CarsLoaded(
            cars: updatedCars,
            hasNextPage: response.pagination.hasNext,
            currentPage: response.pagination.currentPage,
            totalPages: response.pagination.totalPages,
            isLoadingMore: false,
          ));
        }
      } catch (e) {
        final currentState = state;
        if (currentState is CarsLoaded) {
          emit(currentState.copyWith(isLoadingMore: false));
        } else {
          emit(CarError(e.toString()));
        }
      }
    });
  }
}