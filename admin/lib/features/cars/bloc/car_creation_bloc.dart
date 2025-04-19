import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../models/car_creation_session.dart';

// Events
abstract class CarCreationEvent extends Equatable {
  const CarCreationEvent();

  @override
  List<Object?> get props => [];
}

class InitiateCarCreation extends CarCreationEvent {
  const InitiateCarCreation();
}

class UpdateBasicDetails extends CarCreationEvent {
  final BasicDetailsStep details;

  const UpdateBasicDetails(this.details);

  @override
  List<Object?> get props => [details];
}

class UpdateOwnerInfo extends CarCreationEvent {
  final OwnerInfoStep info;

  const UpdateOwnerInfo(this.info);

  @override
  List<Object?> get props => [info];
}

class UpdateLocationDetails extends CarCreationEvent {
  final LocationDetailsStep details;

  const UpdateLocationDetails(this.details);

  @override
  List<Object?> get props => [details];
}

class UpdateRentalInfo extends CarCreationEvent {
  final RentalInfoStep info;

  const UpdateRentalInfo(this.info);

  @override
  List<Object?> get props => [info];
}

class UpdateDocumentsMedia extends CarCreationEvent {
  final DocumentsMediaStep media;

  const UpdateDocumentsMedia(this.media);

  @override
  List<Object?> get props => [media];
}

class UpdateStatusInfo extends CarCreationEvent {
  final StatusInfoStep info;

  const UpdateStatusInfo(this.info);

  @override
  List<Object?> get props => [info];
}

class CompleteCarCreation extends CarCreationEvent {
  const CompleteCarCreation();
}

// States
abstract class CarCreationState extends Equatable {
  const CarCreationState();

  @override
  List<Object?> get props => [];
}

class CarCreationInitial extends CarCreationState {}

class CarCreationLoading extends CarCreationState {}

class CarCreationSessionCreated extends CarCreationState {
  final CarCreationSession session;

  const CarCreationSessionCreated(this.session);

  @override
  List<Object?> get props => [session];
}

class CarCreationError extends CarCreationState {
  final String message;

  const CarCreationError(this.message);

  @override
  List<Object?> get props => [message];
}

class CarCreationComplete extends CarCreationState {
  final CarCreationSession session;

  const CarCreationComplete(this.session);

  @override
  List<Object?> get props => [session];
}

// Bloc
class CarCreationBloc extends Bloc<CarCreationEvent, CarCreationState> {
  CarCreationBloc() : super(CarCreationInitial()) {
    on<InitiateCarCreation>(_onInitiateCarCreation);
    on<UpdateBasicDetails>(_onUpdateBasicDetails);
    on<UpdateOwnerInfo>(_onUpdateOwnerInfo);
    on<UpdateLocationDetails>(_onUpdateLocationDetails);
    on<UpdateRentalInfo>(_onUpdateRentalInfo);
    on<UpdateDocumentsMedia>(_onUpdateDocumentsMedia);
    on<UpdateStatusInfo>(_onUpdateStatusInfo);
    on<CompleteCarCreation>(_onCompleteCarCreation);
  }

  void _onInitiateCarCreation(
    InitiateCarCreation event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      final session = CarCreationSession(id: const Uuid().v4());
      emit(CarCreationSessionCreated(session));
    } catch (e) {
      emit(CarCreationError('Failed to initiate car creation: $e'));
    }
  }

  void _onUpdateBasicDetails(
    UpdateBasicDetails event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        final updatedSession = currentSession.copyWith(
          basicDetails: event.details,
        );
        emit(CarCreationSessionCreated(updatedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to update basic details: $e'));
    }
  }

  void _onUpdateOwnerInfo(
    UpdateOwnerInfo event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        final updatedSession = currentSession.copyWith(
          ownerInfo: event.info,
        );
        emit(CarCreationSessionCreated(updatedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to update owner info: $e'));
    }
  }

  void _onUpdateLocationDetails(
    UpdateLocationDetails event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        final updatedSession = currentSession.copyWith(
          locationDetails: event.details,
        );
        emit(CarCreationSessionCreated(updatedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to update location details: $e'));
    }
  }

  void _onUpdateRentalInfo(
    UpdateRentalInfo event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        final updatedSession = currentSession.copyWith(
          rentalInfo: event.info,
        );
        emit(CarCreationSessionCreated(updatedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to update rental info: $e'));
    }
  }

  void _onUpdateDocumentsMedia(
    UpdateDocumentsMedia event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        final updatedSession = currentSession.copyWith(
          documentsMedia: event.media,
        );
        emit(CarCreationSessionCreated(updatedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to update documents and media: $e'));
    }
  }

  void _onUpdateStatusInfo(
    UpdateStatusInfo event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        final updatedSession = currentSession.copyWith(
          statusInfo: event.info,
        );
        emit(CarCreationSessionCreated(updatedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to update status info: $e'));
    }
  }

  void _onCompleteCarCreation(
    CompleteCarCreation event,
    Emitter<CarCreationState> emit,
  ) {
    try {
      if (state is CarCreationSessionCreated) {
        final currentSession = (state as CarCreationSessionCreated).session;
        
        // Validate all steps are complete
        if (!currentSession.basicDetails.isComplete ||
            !currentSession.ownerInfo.isComplete ||
            !currentSession.locationDetails.isComplete ||
            !currentSession.rentalInfo.isComplete ||
            !currentSession.documentsMedia.isComplete ||
            !currentSession.statusInfo.isComplete) {
          emit(const CarCreationError('All steps must be completed'));
          return;
        }

        final completedSession = currentSession.copyWith(isComplete: true);
        emit(CarCreationComplete(completedSession));
      }
    } catch (e) {
      emit(CarCreationError('Failed to complete car creation: $e'));
    }
  }
} 