import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/car.dart';
import '../../../core/services/api_service.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool _isLoading = false;

  Future<void> _toggleAvailability(Car car) async {
    setState(() => _isLoading = true);

    try {
      await context.read<ApiService>().put<Car>(
        '/api/cars/${car.id}',
        data: {
          'is_available': !car.isAvailable,
        },
        fromJson: (json) => Car.fromJson(json),
      );

      if (mounted) {
        Navigator.pop(context, true); // Refresh car list
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

  Future<void> _deleteCar(Car car) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car'),
        content: Text('Are you sure you want to delete ${car.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await context.read<ApiService>().delete<Car>(
        '/api/cars/${car.id}',
        fromJson: (json) => Car.fromJson(json),
      );
      if (mounted) {
        Navigator.pop(context, true); // Refresh car list
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
    final car = ModalRoute.of(context)!.settings.arguments as Car;

    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      '/cars/edit',
                      arguments: car,
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : () => _deleteCar(car),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Model', car.model),
                          const Divider(),
                          _buildInfoRow('License Plate', car.licensePlate),
                          const Divider(),
                          _buildInfoRow('Location', car.location),
                          const Divider(),
                          _buildInfoRow(
                            'Hourly Rate',
                            '\$${car.hourlyRate.toStringAsFixed(2)}/hr',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            'Status',
                            car.isAvailable ? 'Available' : 'Not Available',
                            valueColor:
                                car.isAvailable ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _toggleAvailability(car),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: car.isAvailable
                            ? Colors.orange
                            : Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        car.isAvailable
                            ? 'Mark as Unavailable'
                            : 'Mark as Available',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
} 