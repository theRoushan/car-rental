import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/owner_repository.dart';
import 'owner_event.dart';
import 'owner_state.dart';

class OwnerBloc extends Bloc<OwnerEvent, OwnerState> {
  final OwnerRepository _ownerRepository;

  OwnerBloc(this._ownerRepository) : super(const OwnerInitial()) {
    on<LoadOwners>(_onLoadOwners);
    on<LoadOwnerDetails>(_onLoadOwnerDetails);
    on<CreateOwner>(_onCreateOwner);
    on<UpdateOwner>(_onUpdateOwner);
    on<DeleteOwner>(_onDeleteOwner);
  }

  Future<void> _onLoadOwners(
    LoadOwners event,
    Emitter<OwnerState> emit,
  ) async {
    emit(const OwnerLoading());
    try {
      final owners = await _ownerRepository.getOwners();
      emit(OwnersLoaded(owners));
    } catch (e) {
      emit(OwnerError(e.toString()));
    }
  }

  Future<void> _onLoadOwnerDetails(
    LoadOwnerDetails event,
    Emitter<OwnerState> emit,
  ) async {
    emit(const OwnerLoading());
    try {
      final owner = await _ownerRepository.getOwner(event.ownerId);
      if (owner != null) {
        emit(OwnerDetailsLoaded(owner));
      } else {
        emit(const OwnerError('Owner not found'));
      }
    } catch (e) {
      emit(OwnerError(e.toString()));
    }
  }

  Future<void> _onCreateOwner(
    CreateOwner event,
    Emitter<OwnerState> emit,
  ) async {
    emit(const OwnerLoading());
    try {
      final owner = await _ownerRepository.createOwner(event.ownerData);
      if (owner != null) {
        emit(OwnerCreated(owner));
      } else {
        emit(const OwnerError('Failed to create owner'));
      }
    } catch (e) {
      emit(OwnerError(e.toString()));
    }
  }

  Future<void> _onUpdateOwner(
    UpdateOwner event,
    Emitter<OwnerState> emit,
  ) async {
    emit(const OwnerLoading());
    try {
      final owner = await _ownerRepository.updateOwner(
        event.ownerId,
        event.ownerData,
      );
      if (owner != null) {
        emit(OwnerUpdated(owner));
      } else {
        emit(const OwnerError('Failed to update owner'));
      }
    } catch (e) {
      emit(OwnerError(e.toString()));
    }
  }

  Future<void> _onDeleteOwner(
    DeleteOwner event,
    Emitter<OwnerState> emit,
  ) async {
    emit(const OwnerLoading());
    try {
      final owner = await _ownerRepository.deleteOwner(event.ownerId);
      if (owner != null) {
        emit(OwnerDeleted(event.ownerId));
      } else {
        emit(const OwnerError('Failed to delete owner'));
      }
    } catch (e) {
      emit(OwnerError(e.toString()));
    }
  }
} 