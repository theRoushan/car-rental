import 'package:equatable/equatable.dart';

abstract class OwnerEvent extends Equatable {
  const OwnerEvent();

  @override
  List<Object?> get props => [];
}

class LoadOwners extends OwnerEvent {
  const LoadOwners();
}

class LoadOwnerDetails extends OwnerEvent {
  final String ownerId;
  
  const LoadOwnerDetails(this.ownerId);
  
  @override
  List<Object?> get props => [ownerId];
}

class CreateOwner extends OwnerEvent {
  final Map<String, dynamic> ownerData;
  
  const CreateOwner(this.ownerData);
  
  @override
  List<Object?> get props => [ownerData];
}

class UpdateOwner extends OwnerEvent {
  final String ownerId;
  final Map<String, dynamic> ownerData;
  
  const UpdateOwner(this.ownerId, this.ownerData);
  
  @override
  List<Object?> get props => [ownerId, ownerData];
}

class DeleteOwner extends OwnerEvent {
  final String ownerId;
  
  const DeleteOwner(this.ownerId);
  
  @override
  List<Object?> get props => [ownerId];
} 