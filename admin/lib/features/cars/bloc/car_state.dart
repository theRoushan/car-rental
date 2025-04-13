import 'package:equatable/equatable.dart';
import '../models/car.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarsLoaded extends CarState {
  final List<Car> cars;

  const CarsLoaded(this.cars);

  @override
  List<Object?> get props => [cars];
}

class CarLoaded extends CarState {
  final Car car;

  const CarLoaded(this.car);

  @override
  List<Object?> get props => [car];
}

class CarError extends CarState {
  final String message;

  const CarError(this.message);

  @override
  List<Object?> get props => [message];
}

class CarOperationSuccess extends CarState {
  final String message;
  final Car? car;

  const CarOperationSuccess({
    required this.message,
    this.car,
  });

  @override
  List<Object?> get props => [message, car];
} 