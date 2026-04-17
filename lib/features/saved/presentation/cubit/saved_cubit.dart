import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../explore/domain/entities/property.dart';
import '../../../explore/domain/repositories/property_repository.dart';

part 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit({required this.propertyRepository}) : super(SavedInitial());

  final PropertyRepository propertyRepository;

  Future<void> loadSaved() async {
    emit(SavedLoading());
    try {
      final saved = await propertyRepository.getSavedProperties();
      emit(SavedLoaded(properties: saved));
    } catch (e) {
      emit(SavedError(e.toString()));
    }
  }

  Future<void> toggleSave(String propertyId) async {
    await propertyRepository.toggleSave(propertyId);
    await loadSaved();
  }
}
