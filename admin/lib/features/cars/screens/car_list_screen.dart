import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import '../models/car.dart';
import 'car_details_screen.dart';
import 'create_car_screen.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showOnlyAvailable = false;

  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(LoadCars());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _toggleAvailabilityFilter(bool? value) {
    setState(() {
      _showOnlyAvailable = value ?? false;
    });
  }

  List<Car> _filterCars(List<Car> cars) {
    return cars.where((car) {
      // Filter by availability if needed
      if (_showOnlyAvailable && !car.isAvailable) {
        return false;
      }

      // Filter by search query if present
      if (_searchQuery.isNotEmpty) {
        return car.make.toLowerCase().contains(_searchQuery) ||
            car.model.toLowerCase().contains(_searchQuery) ||
            car.vehicleNumber.toLowerCase().contains(_searchQuery);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Search
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Car Inventory',
                    style: AppTheme.headingLarge,
                  ),
                ),
                AppButton(
                  label: 'Add New Car',
                  icon: Icons.add,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCarScreen(),
                      ),
                    ).then((_) {
                      // Refresh car list after returning from create screen
                      context.read<CarBloc>().add(LoadCars());
                    });
                  },
                  isFullWidth: false,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            
            // Search and Filter
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    labelText: 'Search cars',
                    hintText: 'Search by make, model, or vehicle number',
                    controller: _searchController,
                    prefixIcon: Icons.search,
                    onChanged: _onSearch,
                  ),
                ),
                const SizedBox(width: AppTheme.defaultSpacing),
                Row(
                  children: [
                    Checkbox(
                      value: _showOnlyAvailable,
                      onChanged: _toggleAvailabilityFilter,
                      activeColor: AppTheme.primaryColor,
                    ),
                    const Text('Available only'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            
            // Car List
            Expanded(
              child: BlocBuilder<CarBloc, CarState>(
                builder: (context, state) {
                  if (state is CarLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (state is CarError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppTheme.errorColor,
                            size: 48,
                          ),
                          const SizedBox(height: AppTheme.mediumSpacing),
                          Text(
                            'Error: ${state.message}',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.errorColor,
                            ),
                          ),
                          const SizedBox(height: AppTheme.defaultSpacing),
                          AppButton(
                            label: 'Try Again',
                            onPressed: () {
                              context.read<CarBloc>().add(LoadCars());
                            },
                            type: ButtonType.secondary,
                            isFullWidth: false,
                            icon: Icons.refresh,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is CarsLoaded) {
                    final filteredCars = _filterCars(state.cars);
                    
                    if (filteredCars.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.do_not_disturb,
                              color: AppTheme.textSecondary,
                              size: 48,
                            ),
                            const SizedBox(height: AppTheme.mediumSpacing),
                            Text(
                              _searchQuery.isNotEmpty || _showOnlyAvailable
                                  ? 'No cars match your filters'
                                  : 'No cars available',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty || _showOnlyAvailable) ...[
                              const SizedBox(height: AppTheme.defaultSpacing),
                              AppButton(
                                label: 'Clear Filters',
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                    _showOnlyAvailable = false;
                                  });
                                },
                                type: ButtonType.secondary,
                                isFullWidth: false,
                                icon: Icons.filter_alt_off,
                              ),
                            ],
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) {
                        final car = filteredCars[index];
                        return _buildCarCard(car);
                      },
                    );
                  }
                  
                  return const Center(
                    child: Text('No data available'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.defaultSpacing),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailsScreen(car: car),
          ),
        ).then((_) {
          // Refresh car list after returning from details screen
          context.read<CarBloc>().add(LoadCars());
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car image or placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightColor,
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                  image: car.images != null && car.images!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(car.images!.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: car.images == null || car.images!.isEmpty
                    ? const Icon(
                        Icons.directions_car,
                        color: AppTheme.primaryColor,
                        size: 40,
                      )
                    : null,
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              // Car details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${car.make} ${car.model} (${car.year})',
                      style: AppTheme.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.variant,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.vehicleNumber,
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Price and status indicators
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.mediumSpacing,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: car.isAvailable
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      borderRadius:
                          BorderRadius.circular(AppTheme.smallRadius),
                    ),
                    child: Text(
                      car.isAvailable ? 'Available' : 'Unavailable',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.mediumSpacing),
                  if (car.rentalPricePerDay != null)
                    Text(
                      '₹${car.rentalPricePerDay!.toStringAsFixed(0)}/day',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  if (car.rentalPricePerHour != null)
                    Text(
                      '₹${car.rentalPricePerHour!.toStringAsFixed(0)}/hr',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          // Additional info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(
                Icons.local_gas_station,
                car.fuelType.toString().split('.').last,
              ),
              _buildInfoChip(
                Icons.settings,
                car.transmission.toString().split('.').last,
              ),
              _buildInfoChip(
                Icons.airline_seat_recline_normal,
                '${car.seatingCapacity} Seats',
              ),
              _buildInfoChip(
                Icons.directions_car,
                car.bodyType.toString().split('.').last,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.mediumSpacing,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryLightColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryDarkColor,
            ),
          ),
        ],
      ),
    );
  }
} 