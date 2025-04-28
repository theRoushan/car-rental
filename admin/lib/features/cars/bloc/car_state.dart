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
  final bool hasNextPage;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final String? searchQuery;

  const CarsLoaded({
    required this.cars, 
    required this.hasNextPage, 
    this.currentPage = 1, 
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [cars, hasNextPage, currentPage, totalPages, isLoadingMore, searchQuery];

  CarsLoaded copyWith({
    List<Car>? cars,
    bool? hasNextPage,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    String? searchQuery,
  }) {
    return CarsLoaded(
      cars: cars ?? this.cars,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
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