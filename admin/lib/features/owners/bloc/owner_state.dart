import 'package:equatable/equatable.dart';

import '../models/owner.dart';

abstract class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object?> get props => [];
}

class OwnerInitial extends OwnerState {
  const OwnerInitial();
}

class OwnerLoading extends OwnerState {
  const OwnerLoading();
}

class OwnersLoaded extends OwnerState {
  final List<Owner> owners;

  const OwnersLoaded(this.owners);

  @override
  List<Object?> get props => [owners];
}

class OwnerDetailsLoaded extends OwnerState {
  final Owner owner;

  const OwnerDetailsLoaded(this.owner);

  @override
  List<Object?> get props => [owner];
}

class OwnerCreated extends OwnerState {
  final Owner owner;

  const OwnerCreated(this.owner);

  @override
  List<Object?> get props => [owner];
}

class OwnerUpdated extends OwnerState {
  final Owner owner;

  const OwnerUpdated(this.owner);

  @override
  List<Object?> get props => [owner];
}

class OwnerDeleted extends OwnerState {
  final String ownerId;

  const OwnerDeleted(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}

class OwnerError extends OwnerState {
  final String message;

  const OwnerError(this.message);

  @override
  List<Object?> get props => [message];
} 