import 'package:car_rental_admin/core/design/components/app_card.dart';
import 'package:car_rental_admin/features/cars/bloc/car_creation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarCreationScreen extends StatefulWidget {
  const CarCreationScreen({super.key});

  @override
  State<CarCreationScreen> createState() => _CarCreationScreenState();
}

class _CarCreationScreenState extends State<CarCreationScreen> {
  final _pageController = PageController();
  String? _sessionId;
  int _currentStep = 0;

  final List<String> _steps = [
    'Basic Details',
    'Owner Information',
    'Location Details',
    'Rental Information',
    'Documents & Media',
    'Status & Maintenance',
  ];

  @override
  void initState() {
    super.initState();
    context.read<CarCreationBloc>().add(const InitiateCarCreation());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Car'),
      ),
      body: BlocConsumer<CarCreationBloc, CarCreationState>(
        listener: (context, state) {
          if (state is CarCreationSessionCreated) {
            setState(() {
              _sessionId = state.session.id;
            });
          } else if (state is CarCreationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CarCreationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Stepper(
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                type: StepperType.horizontal,
                steps: _steps
                    .asMap()
                    .map(
                      (index, title) => MapEntry(
                        index,
                        Step(
                          title: Text(title),
                          content: Container(),
                          isActive: _currentStep >= index,
                          state: _currentStep > index
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _BasicDetailsStep(sessionId: _sessionId),
                    _OwnerInfoStep(sessionId: _sessionId),
                    _LocationDetailsStep(sessionId: _sessionId),
                    _RentalInfoStep(sessionId: _sessionId),
                    _DocumentsMediaStep(sessionId: _sessionId),
                    _StatusInfoStep(sessionId: _sessionId),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BasicDetailsStep extends StatelessWidget {
  final String? sessionId;

  const _BasicDetailsStep({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Make',
                hintText: 'Enter car make',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'Enter car model',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Year',
                hintText: 'Enter car year',
              ),
              keyboardType: TextInputType.number,
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}

class _OwnerInfoStep extends StatelessWidget {
  final String? sessionId;

  const _OwnerInfoStep({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Owner Name',
                hintText: 'Enter owner name',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                hintText: 'Enter contact number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}

class _LocationDetailsStep extends StatelessWidget {
  final String? sessionId;

  const _LocationDetailsStep({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter car location address',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'City',
                hintText: 'Enter city',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'State/Province',
                hintText: 'Enter state or province',
              ),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}

class _RentalInfoStep extends StatelessWidget {
  final String? sessionId;

  const _RentalInfoStep({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Daily Rate',
                hintText: 'Enter daily rental rate',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Weekly Rate',
                hintText: 'Enter weekly rental rate',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Monthly Rate',
                hintText: 'Enter monthly rental rate',
              ),
              keyboardType: TextInputType.number,
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}

class _DocumentsMediaStep extends StatelessWidget {
  final String? sessionId;

  const _DocumentsMediaStep({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement document upload
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Documents'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement image upload
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Photos'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement video upload
            },
            icon: const Icon(Icons.videocam),
            label: const Text('Add Videos'),
          ),
          // Add more upload options as needed
        ],
      ),
    );
  }
}

class _StatusInfoStep extends StatelessWidget {
  final String? sessionId;

  const _StatusInfoStep({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Availability Status',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'available',
                  child: Text('Available'),
                ),
                DropdownMenuItem(
                  value: 'maintenance',
                  child: Text('Under Maintenance'),
                ),
                DropdownMenuItem(
                  value: 'reserved',
                  child: Text('Reserved'),
                ),
              ],
              onChanged: (value) {
                // TODO: Handle status change
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Last Maintenance Date',
                hintText: 'Enter last maintenance date',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Next Maintenance Due',
                hintText: 'Enter next maintenance due date',
              ),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
} 