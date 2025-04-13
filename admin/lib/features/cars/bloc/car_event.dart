import 'package:equatable/equatable.dart';
import '../models/car.dart';

abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

class LoadCars extends CarEvent {}

class LoadCar extends CarEvent {
  final String id;

  const LoadCar(this.id);

  @override
  List<Object?> get props => [id];
}

class AddCar extends CarEvent {
  final Car car;

  const AddCar(this.car);

  @override
  List<Object?> get props => [car];
}

class UpdateCar extends CarEvent {
  final Car car;

  const UpdateCar(this.car);

  @override
  List<Object?> get props => [car];
}

class DeleteCar extends CarEvent {
  final String id;

  const DeleteCar(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleCarAvailability extends CarEvent {
  final String id;
  final bool isAvailable;

  const ToggleCarAvailability({
    required this.id,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, isAvailable];
}

class SearchCars extends CarEvent {
  final String query;

  const SearchCars(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterCars extends CarEvent {
  final String? brand;
  final String? model;
  final String? year;
  final bool? isAvailable;
  final double? minPrice;
  final double? maxPrice;

  const FilterCars({
    this.brand,
    this.model,
    this.year,
    this.isAvailable,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [
        brand,
        model,
        year,
        isAvailable,
        minPrice,
        maxPrice,
      ];
} 