import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/car.dart';
import '../../../core/services/api_service.dart';

class CarFormScreen extends StatefulWidget {
  const CarFormScreen({super.key});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _locationController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  bool _isAvailable = true;
  bool _isLoading = false;
  bool _isEditMode = false;
  String? _carId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final car = ModalRoute.of(context)?.settings.arguments as Car?;
      if (car != null) {
        _isEditMode = true;
        _carId = car.id;
        _nameController.text = car.name;
        _modelController.text = car.model;
        _licensePlateController.text = car.licensePlate;
        _locationController.text = car.location;
        _hourlyRateController.text = car.hourlyRate.toString();
        setState(() {
          _isAvailable = car.isAvailable;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _licensePlateController.dispose();
    _locationController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'name': _nameController.text,
      'model': _modelController.text,
      'license_plate': _licensePlateController.text,
      'location': _locationController.text,
      'hourly_rate': double.parse(_hourlyRateController.text),
      'is_available': _isAvailable,
    };

    try {
      if (_isEditMode) {
        await context.read<ApiService>().put<Car>(
              '/api/cars/$_carId',
              data: data,
              fromJson: (json) => Car.fromJson(json),
            );
      } else {
        await context.read<ApiService>().post<Car>(
              '/api/cars',
              data: data,
              fromJson: (json) => Car.fromJson(json),
            );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Car' : 'Add Car'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter car name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        hintText: 'Enter car model',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car model';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _licensePlateController,
                      decoration: const InputDecoration(
                        labelText: 'License Plate',
                        hintText: 'Enter license plate number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter license plate number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Enter car location',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _hourlyRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hourly Rate',
                        hintText: 'Enter hourly rate',
                        prefixText: '\$ ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter hourly rate';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Hourly rate must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Available'),
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: Text(_isEditMode ? 'Update Car' : 'Add Car'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 