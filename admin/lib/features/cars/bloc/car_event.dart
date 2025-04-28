import 'package:car_rental_admin/features/cars/models/car.dart';
import 'package:equatable/equatable.dart';

abstract class CarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCars extends CarEvent {
  final int page;
  final int limit;
  final String? vehicleNumber;

  LoadCars({this.page = 1, this.limit = 10, this.vehicleNumber});

  @override
  List<Object?> get props => [page, limit, vehicleNumber];
}

class LoadMoreCars extends CarEvent {
  final int limit;

  LoadMoreCars({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class LoadCar extends CarEvent {
  final String id;

  LoadCar(this.id);

  @override
  List<Object?> get props => [id];
}

class AddCar extends CarEvent {
  final Car car;

   AddCar(this.car);

  @override
  List<Object?> get props => [car];
}

class UpdateCar extends CarEvent {
  final Car car;

   UpdateCar(this.car);

  @override
  List<Object?> get props => [car];
}

class DeleteCar extends CarEvent {
  final String id;

   DeleteCar(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleCarAvailability extends CarEvent {
  final String id;
  final bool isAvailable;

   ToggleCarAvailability({
    required this.id,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, isAvailable];
}

class SearchCars extends CarEvent {
  final String query;

   SearchCars(this.query);

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

   FilterCars({
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

class SearchByVehicleNumber extends CarEvent {
  final String vehicleNumber;

  SearchByVehicleNumber(this.vehicleNumber);

  @override
  List<Object?> get props => [vehicleNumber];
}