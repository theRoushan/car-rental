import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_theme.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import '../models/car.dart';
import 'components/car_form.dart';

class EditCarScreen extends StatefulWidget {
  final Car car;

  const EditCarScreen({super.key, required this.car});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Car'),
      ),
      body: BlocListener<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Car updated successfully!'),
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
            setState(() {
              _isSubmitting = false;
            });
          } else if (state is CarLoading) {
            setState(() {
              _isSubmitting = true;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Car Details',
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: AppTheme.mediumSpacing),
              Text(
                'Update the car information below',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing * 2),
              CarForm(
                car: widget.car,
                onSubmit: (carData) {
                  // Use the existing car's id and timestamps
                  carData['id'] = widget.car.id;
                  carData['created_at'] = widget.car.createdAt;
                  carData['updated_at'] = DateTime.now().toIso8601String();
                  
                  // Convert to proper enum format for parsing
                  carData['fuel_type'] = carData['fuel_type'].toString();
                  carData['transmission'] = carData['transmission'].toString();
                  carData['body_type'] = carData['body_type'].toString();
                  
                  final car = Car.fromJson(carData);
                  context.read<CarBloc>().add(UpdateCar(car));
                },
                isSubmitting: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 