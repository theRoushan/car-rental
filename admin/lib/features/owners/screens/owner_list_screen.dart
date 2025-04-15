import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/owner_bloc.dart';
import '../bloc/owner_event.dart';
import '../bloc/owner_state.dart';
import '../models/owner.dart';

class OwnerListScreen extends StatefulWidget {
  const OwnerListScreen({super.key});

  @override
  State<OwnerListScreen> createState() => _OwnerListScreenState();
}

class _OwnerListScreenState extends State<OwnerListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerBloc>().add(const LoadOwners());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OwnerBloc, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is OwnerError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          
          if (state is OwnersLoaded) {
            return _buildOwnerList(state.owners);
          }
          
          return const Center(child: Text('No owners data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create owner screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOwnerList(List<Owner> owners) {
    if (owners.isEmpty) {
      return const Center(child: Text('No owners available'));
    }
    
    return ListView.builder(
      itemCount: owners.length,
      itemBuilder: (context, index) {
        final owner = owners[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(owner.name),
            subtitle: Text(owner.contactInfo),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // TODO: Navigate to edit owner screen
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(owner);
                  },
                ),
              ],
            ),
            onTap: () {
              // TODO: Navigate to owner details screen
            },
          ),
        );
      },
    );
  }
  
  void _showDeleteConfirmation(Owner owner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Owner'),
        content: Text('Are you sure you want to delete ${owner.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OwnerBloc>().add(DeleteOwner(owner.id));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 