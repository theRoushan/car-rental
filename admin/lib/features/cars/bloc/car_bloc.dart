import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/car_repository.dart';
import 'car_event.dart';
import 'car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final CarRepository _carRepository;

  CarBloc({required CarRepository carRepository})
      : _carRepository = carRepository,
        super(CarInitial()) {
    on<LoadCars>(_onLoadCars);
    on<LoadCar>(_onLoadCar);
    on<AddCar>(_onAddCar);
    on<UpdateCar>(_onUpdateCar);
    on<DeleteCar>(_onDeleteCar);
    on<ToggleCarAvailability>(_onToggleCarAvailability);
    on<SearchCars>(_onSearchCars);
    on<FilterCars>(_onFilterCars);
  }

  Future<void> _onLoadCars(LoadCars event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final cars = await _carRepository.getCars();
      emit(CarsLoaded(cars));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onLoadCar(LoadCar event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final car = await _carRepository.getCar(event.id);
      emit(CarLoaded(car));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onAddCar(AddCar event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final car = await _carRepository.createCar(event.car);
      emit(CarOperationSuccess(
        message: 'Car added successfully',
        car: car,
      ));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onUpdateCar(UpdateCar event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final car = await _carRepository.updateCar(event.car);
      emit(CarOperationSuccess(
        message: 'Car updated successfully',
        car: car,
      ));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onDeleteCar(DeleteCar event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      await _carRepository.deleteCar(event.id);
      emit(const CarOperationSuccess(message: 'Car deleted successfully'));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onToggleCarAvailability(
    ToggleCarAvailability event,
    Emitter<CarState> emit,
  ) async {
    emit(CarLoading());
    try {
      final car = await _carRepository.toggleCarAvailability(
        event.id,
        event.isAvailable,
      );
      emit(CarOperationSuccess(
        message: 'Car availability updated successfully',
        car: car,
      ));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onSearchCars(SearchCars event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final cars = await _carRepository.searchCars(event.query);
      emit(CarsLoaded(cars));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> _onFilterCars(FilterCars event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final cars = await _carRepository.filterCars(
        brand: event.brand,
        model: event.model,
        year: event.year,
        isAvailable: event.isAvailable,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );
      emit(CarsLoaded(cars));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }
} 