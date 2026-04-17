import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../explore/domain/entities/property.dart';
import '../../../explore/domain/repositories/property_repository.dart';

part 'property_detail_state.dart';

class PropertyDetailCubit extends Cubit<PropertyDetailState> {
  PropertyDetailCubit(this._repository) : super(PropertyDetailLoading());

  final PropertyRepository _repository;

  Future<void> load(String id) async {
    emit(PropertyDetailLoading());
    try {
      final property = await _repository.getPropertyById(id);
      if (property != null) {
        emit(PropertyDetailLoaded(property: property));
      } else {
        emit(const PropertyDetailError('Property not found'));
      }
    } catch (e) {
      emit(PropertyDetailError(e.toString()));
    }
  }

  Future<void> toggleSave() async {
    final current = state;
    if (current is! PropertyDetailLoaded) return;

    await _repository.toggleSave(current.property.id);
    emit(PropertyDetailLoaded(
      property: current.property.copyWith(isSaved: !current.property.isSaved),
    ));
  }
}
