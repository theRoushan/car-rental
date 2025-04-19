import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_theme.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';
import 'components/car_form.dart';
import '../models/car.dart';

class CreateCarScreen extends StatefulWidget {
  const CreateCarScreen({super.key});

  @override
  State<CreateCarScreen> createState() => _CreateCarScreenState();
}

class _CreateCarScreenState extends State<CreateCarScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Car'),
      ),
      body: BlocListener<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarOperationSuccess && state.message.contains('created')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Car created successfully!'),
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
                'Add a New Car',
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: AppTheme.mediumSpacing),
              Text(
                'Fill in the details below to add a new car to the fleet',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing * 2),
              CarForm(
                onSubmit: (carData) {
                  // Add required fields for Car.fromJson that aren't in the form
                  carData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
                  carData['created_at'] = DateTime.now().toIso8601String();
                  carData['updated_at'] = DateTime.now().toIso8601String();
                  
                  // Convert to proper enum format for parsing
                  carData['fuel_type'] = carData['fuel_type'].toString();
                  carData['transmission'] = carData['transmission'].toString();
                  carData['body_type'] = carData['body_type'].toString();
                  
                  final car = Car.fromJson(carData);
                  context.read<CarBloc>().add(AddCar(car));
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