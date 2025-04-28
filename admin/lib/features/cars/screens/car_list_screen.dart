import 'package:car_rental_admin/core/iconmoon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import '../models/car.dart';
import 'dart:async';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // If we're near the bottom (within 200 pixels), load more items
    if (maxScroll - currentScroll <= 200) {
      final carState = context.read<CarBloc>().state;
      if (carState is CarsLoaded &&
          carState.hasNextPage &&
          !carState.isLoadingMore) {
        context.read<CarBloc>().add(LoadMoreCars());
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        context.read<CarBloc>().add(LoadCars());
      } else {
        context.read<CarBloc>().add(SearchByVehicleNumber(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter/Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by vehicle number',
                      prefixIcon: const Icon(Icomoon.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 55,
                  child: const Icon(Icons.add),),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[400],
            width: double.infinity,
          ),
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No cars available'),
                          if (state.searchQuery != null && state.searchQuery!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<CarBloc>().add(LoadCars());
                                },
                                child: const Text('Clear search'),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
                        context.read<CarBloc>().add(SearchByVehicleNumber(state.searchQuery!));
                      } else {
                        context.read<CarBloc>().add(LoadCars());
                      }
                    },
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // Search filter indicator
                            if (state.searchQuery != null && state.searchQuery!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Vehicle Number: ${state.searchQuery}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      InkWell(
                                        onTap: () {
                                          _searchController.clear();
                                          context.read<CarBloc>().add(LoadCars());
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: state.cars.length +
                                    (state.isLoadingMore || state.hasNextPage
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  // If we've reached the end and there's more to load or we're loading more
                                  if (index >= state.cars.length) {
                                    return state.isLoadingMore
                                        ? const Padding(
                                            padding:
                                                EdgeInsets.symmetric(vertical: 16),
                                            child: Center(
                                                child: CircularProgressIndicator()),
                                          )
                                        : const SizedBox
                                            .shrink(); // Just to hold the space for pagination
                                  }

                                  final car = state.cars[index];
                                  return CarCard(car: car);
                                },
                              ),
                            ),
                          ],
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
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: null, // Remove the floating action button
    );
  }
}

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: car.isAvailable ? 1.0 : 0.5, // Grey out the card if unavailable
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        '${car.make} ${car.model}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        car.vehicleNumber,
                        style: TextStyle(
                          fontFamily: GoogleFonts.barlow(
                            fontWeight: FontWeight.w600,
                          ).fontFamily,
                        ),
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
                        '${car.transmission} • ${car.fuelType} • ${car.bodyType} • ${car.seatingCapacity} seater',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(), // Divider between elements
        ],
      ),
    );
  }
}
