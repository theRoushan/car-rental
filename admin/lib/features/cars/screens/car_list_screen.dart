import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import '../models/car.dart';

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, state) {
        if (state is CarLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CarError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    context.read<CarBloc>().add(LoadCars());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is CarsLoaded) {
          if (state.cars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No cars available'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      // TODO: Navigate to add car screen
                    },
                    child: const Text('Add Car'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                title: const Text('Cars'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // TODO: Show search dialog
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // TODO: Show filter dialog
                    },
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final car = state.cars[index];
                      return CarCard(car: car);
                    },
                    childCount: state.cars.length,
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to car details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                car.name,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.directions_car,
                      size: 48,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car.model} ${car.model}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    car.licensePlate,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${car.hourlyRate.toStringAsFixed(2)}/day',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        car.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: car.isAvailable
                            ? Colors.green
                            : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        car.isAvailable
                            ? 'Available'
                            : 'Not Available',
                        style: TextStyle(
                          color: car.isAvailable
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 