import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import '../models/car.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    // Load initial cars
    context.read<CarBloc>().add(LoadCars());
    
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    // If we're near the bottom (within 200 pixels), load more items
    if (maxScroll - currentScroll <= 200) {
      final carState = context.read<CarBloc>().state;
      if (carState is CarsLoaded && carState.hasNextPage && !carState.isLoadingMore) {
        context.read<CarBloc>().add(LoadMoreCars());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter/Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name, plate, or location',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      // TODO: Implement search functionality
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Car List (Card View)
          Expanded(
            child: BlocBuilder<CarBloc, CarState>(
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
                    return const Center(child: Text('No cars available'));
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: state.cars.length + (state.isLoadingMore || state.hasNextPage ? 1 : 0),
                        itemBuilder: (context, index) {
                          // If we've reached the end and there's more to load or we're loading more
                          if (index >= state.cars.length) {
                            return state.isLoadingMore 
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              : const SizedBox.shrink(); // Just to hold the space for pagination
                          }
                          
                          final car = state.cars[index];
                          return CarCard(car: car);
                        },
                      ),
                      
                      // Loading overlay for pagination
                      if (state.isLoadingMore)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            color: Colors.black.withOpacity(0.1),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add new car screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                car.images.isNotEmpty ? car.images[0] : '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            // Car Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car.make} ${car.model} ${car.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Plate: ${car.vehicleNumber}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${car.rentalPricePerDay}/day',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: City/Branch', // TODO: Replace with actual location
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Status Badge and Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: car.isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    car.isAvailable ? 'Available' : 'Disabled',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // TODO: Handle actions
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'View', child: Text('View')),
                    const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'Disable', child: Text('Disable')),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}