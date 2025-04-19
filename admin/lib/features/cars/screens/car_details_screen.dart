import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import '../models/car.dart';
import 'edit_car_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final Car car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCarScreen(car: car),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: BlocListener<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarOperationSuccess && state.message.contains('delete')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Car deleted successfully'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            Navigator.pop(context);
          } else if (state is CarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image Gallery
              SizedBox(
                height: 200,
                child: car.images != null && car.images!.isNotEmpty
                    ? PageView.builder(
                        itemCount: car.images!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                              image: DecorationImage(
                                image: NetworkImage(car.images![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLightColor,
                          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing),

              // Basic Information Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppTheme.defaultSpacing),
                    _buildInfoRow('Make', car.make),
                    _buildInfoRow('Model', car.model),
                    _buildInfoRow('Year', car.year.toString()),
                    _buildInfoRow('Variant', car.variant),
                    _buildInfoRow('Fuel Type', car.fuelType.toString().split('.').last),
                    _buildInfoRow('Transmission', car.transmission.toString().split('.').last),
                    _buildInfoRow('Body Type', car.bodyType.toString().split('.').last),
                    _buildInfoRow('Color', car.color),
                    _buildInfoRow('Seating Capacity', car.seatingCapacity.toString()),
                    _buildInfoRow('Vehicle Number', car.vehicleNumber),
                    _buildInfoRow('Registration State', car.registrationState),
                    _buildInfoRow('Owner ID', car.ownerId),
                    if (car.ownerName != null)
                      _buildInfoRow('Owner Name', car.ownerName!),
                    if (car.ownerContact != null)
                      _buildInfoRow('Owner Contact', car.ownerContact!),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing),

              // Location Information Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location Information',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppTheme.defaultSpacing),
                    if (car.currentLocation != null)
                      _buildInfoRow('Current Location', car.currentLocation!),
                    if (car.availableBranches != null && car.availableBranches!.isNotEmpty) ...[
                      const Text('Available Branches'),
                      const SizedBox(height: AppTheme.mediumSpacing),
                      Wrap(
                        spacing: AppTheme.mediumSpacing,
                        runSpacing: AppTheme.mediumSpacing,
                        children: car.availableBranches!.map((branch) {
                          return Chip(
                            label: Text(branch),
                            backgroundColor: AppTheme.primaryLightColor,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing),

              // Rental Information Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rental Information',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppTheme.defaultSpacing),
                    if (car.rentalPricePerDay != null)
                      _buildInfoRow('Price per Day', '₹${car.rentalPricePerDay!.toStringAsFixed(2)}'),
                    if (car.rentalPricePerHour != null)
                      _buildInfoRow('Price per Hour', '₹${car.rentalPricePerHour!.toStringAsFixed(2)}'),
                    if (car.minimumRentDuration != null)
                      _buildInfoRow('Minimum Rent Duration', '${car.minimumRentDuration} hours'),
                    if (car.maximumRentDuration != null)
                      _buildInfoRow('Maximum Rent Duration', '${car.maximumRentDuration} hours'),
                    if (car.securityDeposit != null)
                      _buildInfoRow('Security Deposit', '₹${car.securityDeposit!.toStringAsFixed(2)}'),
                    if (car.lateFeePerHour != null)
                      _buildInfoRow('Late Fee per Hour', '₹${car.lateFeePerHour!.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing),

              // Status Information Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Information',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: AppTheme.defaultSpacing),
                    Row(
                      children: [
                        const Text('Available for Rent: '),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.mediumSpacing,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: car.isAvailable
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                          ),
                          child: Text(
                            car.isAvailable ? 'Yes' : 'No',
                            style: AppTheme.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.mediumSpacing),
                    if (car.currentOdometerReading != null)
                      _buildInfoRow(
                        'Current Odometer Reading',
                        '${car.currentOdometerReading!.toStringAsFixed(0)} km',
                      ),
                    if (car.lastServiceDate != null)
                      _buildInfoRow('Last Service Date', car.lastServiceDate!),
                    if (car.nextServiceDue != null)
                      _buildInfoRow('Next Service Due', car.nextServiceDue!),
                    if (car.damagesOrIssues != null) ...[
                      const SizedBox(height: AppTheme.mediumSpacing),
                      const Text('Damages or Issues:'),
                      const SizedBox(height: AppTheme.smallSpacing),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.mediumSpacing),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLightColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                        ),
                        child: Text(car.damagesOrIssues!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car'),
        content: Text('Are you sure you want to delete ${car.make} ${car.model}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            onPressed: () {
              Navigator.pop(context);
              context.read<CarBloc>().add(DeleteCar(car.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.mediumSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
} 