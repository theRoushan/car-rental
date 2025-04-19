import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../models/car.dart';

class CarForm extends StatefulWidget {
  final Car? car;
  final Function(Map<String, dynamic>) onSubmit;
  final bool isSubmitting;

  const CarForm({
    super.key,
    this.car,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _variantController = TextEditingController();
  final _colorController = TextEditingController();
  final _seatingCapacityController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _registrationStateController = TextEditingController();
  final _ownerIdController = TextEditingController();
  final _currentLocationController = TextEditingController();
  final _rentalPricePerDayController = TextEditingController();
  final _rentalPricePerHourController = TextEditingController();
  final _minimumRentDurationController = TextEditingController();
  final _maximumRentDurationController = TextEditingController();
  final _securityDepositController = TextEditingController();
  final _lateFeePerHourController = TextEditingController();
  final _currentOdometerReadingController = TextEditingController();

  FuelType? _selectedFuelType;
  TransmissionType? _selectedTransmissionType;
  BodyType? _selectedBodyType;
  bool _isAvailable = true;
  List<String> _availableBranches = [];
  List<String> _images = [];
  String? _video;
  String? _lastServiceDate;
  String? _nextServiceDue;
  String? _damagesOrIssues;

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _initializeFormWithCar(widget.car!);
    }
  }

  void _initializeFormWithCar(Car car) {
    _makeController.text = car.make;
    _modelController.text = car.model;
    _yearController.text = car.year.toString();
    _variantController.text = car.variant;
    _colorController.text = car.color;
    _seatingCapacityController.text = car.seatingCapacity.toString();
    _vehicleNumberController.text = car.vehicleNumber;
    _registrationStateController.text = car.registrationState;
    _ownerIdController.text = car.ownerId;
    _currentLocationController.text = car.currentLocation ?? '';
    _rentalPricePerDayController.text =
        car.rentalPricePerDay?.toString() ?? '';
    _rentalPricePerHourController.text =
        car.rentalPricePerHour?.toString() ?? '';
    _minimumRentDurationController.text =
        car.minimumRentDuration?.toString() ?? '';
    _maximumRentDurationController.text =
        car.maximumRentDuration?.toString() ?? '';
    _securityDepositController.text = car.securityDeposit?.toString() ?? '';
    _lateFeePerHourController.text = car.lateFeePerHour?.toString() ?? '';
    _currentOdometerReadingController.text =
        car.currentOdometerReading?.toString() ?? '';

    _selectedFuelType = car.fuelType;
    _selectedTransmissionType = car.transmission;
    _selectedBodyType = car.bodyType;
    _isAvailable = car.isAvailable;
    _availableBranches = car.availableBranches ?? [];
    _images = car.images ?? [];
    _video = car.video;
    _lastServiceDate = car.lastServiceDate;
    _nextServiceDue = car.nextServiceDue;
    _damagesOrIssues = car.damagesOrIssues;
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _variantController.dispose();
    _colorController.dispose();
    _seatingCapacityController.dispose();
    _vehicleNumberController.dispose();
    _registrationStateController.dispose();
    _ownerIdController.dispose();
    _currentLocationController.dispose();
    _rentalPricePerDayController.dispose();
    _rentalPricePerHourController.dispose();
    _minimumRentDurationController.dispose();
    _maximumRentDurationController.dispose();
    _securityDepositController.dispose();
    _lateFeePerHourController.dispose();
    _currentOdometerReadingController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final carData = {
        'make': _makeController.text,
        'model': _modelController.text,
        'year': int.parse(_yearController.text),
        'variant': _variantController.text,
        'fuel_type': _selectedFuelType.toString().split('.').last.toUpperCase(),
        'transmission': _selectedTransmissionType.toString().split('.').last.toUpperCase(),
        'body_type': _selectedBodyType.toString().split('.').last.toUpperCase(),
        'color': _colorController.text,
        'seating_capacity': int.parse(_seatingCapacityController.text),
        'vehicle_number': _vehicleNumberController.text,
        'registration_state': _registrationStateController.text,
        'owner_id': _ownerIdController.text,
        'is_available': _isAvailable,
      };

      // Add optional fields if they are not empty
      if (_currentLocationController.text.isNotEmpty) {
        carData['current_location'] = _currentLocationController.text;
      }

      if (_availableBranches.isNotEmpty) {
        carData['available_branches'] = _availableBranches;
      }

      if (_rentalPricePerDayController.text.isNotEmpty) {
        carData['rental_price_per_day'] =
            double.parse(_rentalPricePerDayController.text);
      }

      if (_rentalPricePerHourController.text.isNotEmpty) {
        carData['rental_price_per_hour'] =
            double.parse(_rentalPricePerHourController.text);
      }

      if (_minimumRentDurationController.text.isNotEmpty) {
        carData['minimum_rent_duration'] =
            int.parse(_minimumRentDurationController.text);
      }

      if (_maximumRentDurationController.text.isNotEmpty) {
        carData['maximum_rent_duration'] =
            int.parse(_maximumRentDurationController.text);
      }

      if (_securityDepositController.text.isNotEmpty) {
        carData['security_deposit'] =
            double.parse(_securityDepositController.text);
      }

      if (_lateFeePerHourController.text.isNotEmpty) {
        carData['late_fee_per_hour'] =
            double.parse(_lateFeePerHourController.text);
      }

      if (_images.isNotEmpty) {
        carData['images'] = _images;
      }

      if (_video != null && _video!.isNotEmpty) {
        carData['video'] = _video!;
      }

      if (_currentOdometerReadingController.text.isNotEmpty) {
        carData['current_odometer_reading'] =
            double.parse(_currentOdometerReadingController.text);
      }

      if (_lastServiceDate != null && _lastServiceDate!.isNotEmpty) {
        carData['last_service_date'] = _lastServiceDate!;
      }

      if (_nextServiceDue != null && _nextServiceDue!.isNotEmpty) {
        carData['next_service_due'] = _nextServiceDue!;
      }

      if (_damagesOrIssues != null && _damagesOrIssues!.isNotEmpty) {
        carData['damages_or_issues'] = _damagesOrIssues!;
      }

      widget.onSubmit(carData);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isLastService) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        if (isLastService) {
          _lastServiceDate = formattedDate;
        } else {
          _nextServiceDue = formattedDate;
        }
      });
    }
  }

  void _addBranch(String branch) {
    if (branch.isEmpty) return;
    setState(() {
      if (!_availableBranches.contains(branch)) {
        _availableBranches.add(branch);
      }
    });
  }

  void _removeBranch(String branch) {
    setState(() {
      _availableBranches.remove(branch);
    });
  }

  void _addImage(String imageUrl) {
    if (imageUrl.isEmpty) return;
    setState(() {
      if (!_images.contains(imageUrl)) {
        _images.add(imageUrl);
      }
    });
  }

  void _removeImage(String imageUrl) {
    setState(() {
      _images.remove(imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          // Make & Model
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Make',
                  hintText: 'e.g., Honda',
                  controller: _makeController,
                  prefixIcon: Icons.directions_car,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'Make',
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Model',
                  hintText: 'e.g., Civic',
                  controller: _modelController,
                  prefixIcon: Icons.car_repair,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'Model',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Year & Variant
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Year',
                  hintText: 'e.g., 2023',
                  controller: _yearController,
                  prefixIcon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: FormValidators.validateYear,
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Variant',
                  hintText: 'e.g., XZ+',
                  controller: _variantController,
                  prefixIcon: Icons.local_offer,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'Variant',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Fuel Type & Transmission
          Row(
            children: [
              Expanded(
                child: AppDropdown<FuelType>(
                  labelText: 'Fuel Type',
                  hintText: 'Select fuel type',
                  value: _selectedFuelType,
                  prefixIcon: Icons.local_gas_station,
                  items: FuelType.values.map((fuelType) {
                    return DropdownMenuItem(
                      value: fuelType,
                      child: Text(
                        fuelType.toString().split('.').last,
                        style: AppTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFuelType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Fuel type is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppDropdown<TransmissionType>(
                  labelText: 'Transmission',
                  hintText: 'Select transmission',
                  value: _selectedTransmissionType,
                  prefixIcon: Icons.settings,
                  items: TransmissionType.values.map((transmissionType) {
                    return DropdownMenuItem(
                      value: transmissionType,
                      child: Text(
                        transmissionType.toString().split('.').last,
                        style: AppTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTransmissionType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Transmission is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Body Type & Color
          Row(
            children: [
              Expanded(
                child: AppDropdown<BodyType>(
                  labelText: 'Body Type',
                  hintText: 'Select body type',
                  value: _selectedBodyType,
                  prefixIcon: Icons.directions_car_filled,
                  items: BodyType.values.map((bodyType) {
                    return DropdownMenuItem(
                      value: bodyType,
                      child: Text(
                        bodyType.toString().split('.').last,
                        style: AppTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBodyType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Body type is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Color',
                  hintText: 'e.g., White',
                  controller: _colorController,
                  prefixIcon: Icons.color_lens,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'Color',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Seating Capacity & Vehicle Number
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Seating Capacity',
                  hintText: 'e.g., 5',
                  controller: _seatingCapacityController,
                  prefixIcon: Icons.airline_seat_recline_normal,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) => FormValidators.validatePositiveNumber(
                    value,
                    'Seating capacity',
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Vehicle Number',
                  hintText: 'e.g., KA01AB1234',
                  controller: _vehicleNumberController,
                  prefixIcon: Icons.pin,
                  validator: FormValidators.validateVehicleNumber,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Registration State & Owner ID
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Registration State',
                  hintText: 'e.g., Karnataka',
                  controller: _registrationStateController,
                  prefixIcon: Icons.location_on,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'Registration state',
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Owner ID',
                  hintText: 'Owner UUID',
                  controller: _ownerIdController,
                  prefixIcon: Icons.person,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'Owner ID',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing * 2),
          
          // Location Information
          Text(
            'Location Information',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          AppTextField(
            labelText: 'Current Location',
            hintText: 'e.g., Bangalore Airport',
            controller: _currentLocationController,
            prefixIcon: Icons.location_on,
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Available Branches - List and add new branch
          Text(
            'Available Branches',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Branch',
                  hintText: 'e.g., Bangalore Central',
                  prefixIcon: Icons.business,
                  onSubmitted: (value) {
                    _addBranch(value);
                    // Clear the field
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              const SizedBox(width: AppTheme.mediumSpacing),
              AppButton(
                label: 'Add',
                onPressed: () {
                  // We handle this in onSubmitted
                },
                type: ButtonType.secondary,
                isFullWidth: false,
                icon: Icons.add,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          if (_availableBranches.isNotEmpty) ...[
            Wrap(
              spacing: AppTheme.mediumSpacing,
              children: _availableBranches.map((branch) {
                return Chip(
                  label: Text(branch),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeBranch(branch),
                  backgroundColor: AppTheme.primaryLightColor,
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
          ],
          
          const SizedBox(height: AppTheme.defaultSpacing * 2),
          
          // Rental Information
          Text(
            'Rental Information',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          // Rental Price per Day & Hour
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Price per Day (₹)',
                  hintText: 'e.g., 2000',
                  controller: _rentalPricePerDayController,
                  prefixIcon: Icons.currency_rupee,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) => FormValidators.validatePositiveNumber(
                    value,
                    'Rental price per day',
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Price per Hour (₹)',
                  hintText: 'e.g., 200',
                  controller: _rentalPricePerHourController,
                  prefixIcon: Icons.currency_rupee,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Minimum & Maximum Rent Duration
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Min Rent Duration (hrs)',
                  hintText: 'e.g., 4',
                  controller: _minimumRentDurationController,
                  prefixIcon: Icons.timer,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Max Rent Duration (hrs)',
                  hintText: 'e.g., 72',
                  controller: _maximumRentDurationController,
                  prefixIcon: Icons.timer_off,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Security Deposit & Late Fee
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Security Deposit (₹)',
                  hintText: 'e.g., 5000',
                  controller: _securityDepositController,
                  prefixIcon: Icons.security,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: AppTextField(
                  labelText: 'Late Fee per Hour (₹)',
                  hintText: 'e.g., 100',
                  controller: _lateFeePerHourController,
                  prefixIcon: Icons.history,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing * 2),
          
          // Status Information
          Text(
            'Status Information',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          // Is Available Switch
          SwitchListTile(
            title: const Text('Available for Rent'),
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(height: AppTheme.mediumSpacing),
          
          // Current Odometer Reading
          AppTextField(
            labelText: 'Current Odometer Reading (km)',
            hintText: 'e.g., 10000',
            controller: _currentOdometerReadingController,
            prefixIcon: Icons.speed,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Last Service Date & Next Service Due
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.defaultSpacing,
                      vertical: AppTheme.defaultSpacing,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.textLight),
                      borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.mediumSpacing),
                        Expanded(
                          child: Text(
                            _lastServiceDate ?? 'Last Service Date',
                            style: _lastServiceDate == null
                                ? AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary)
                                : AppTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.defaultSpacing),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.defaultSpacing,
                      vertical: AppTheme.defaultSpacing,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.textLight),
                      borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.mediumSpacing),
                        Expanded(
                          child: Text(
                            _nextServiceDue ?? 'Next Service Due',
                            style: _nextServiceDue == null
                                ? AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary)
                                : AppTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.defaultSpacing),
          
          // Damages or Issues
          AppTextField(
            labelText: 'Damages or Issues',
            hintText: 'Describe any existing damages or issues with the car',
            maxLines: 3,
            prefixIcon: Icons.warning,
            initialValue: _damagesOrIssues,
            onChanged: (value) {
              _damagesOrIssues = value;
            },
          ),
          const SizedBox(height: AppTheme.defaultSpacing * 2),
          
          // Submit Button
          AppButton(
            label: widget.car == null ? 'Create Car' : 'Update Car',
            onPressed: _submitForm,
            isLoading: widget.isSubmitting,
            icon: widget.car == null ? Icons.add : Icons.update,
          ),
          const SizedBox(height: AppTheme.defaultSpacing * 2),
        ],
      ),
    );
  }
} 