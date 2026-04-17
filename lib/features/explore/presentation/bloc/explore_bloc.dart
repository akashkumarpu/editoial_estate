import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/property.dart';
import '../../domain/usecases/get_properties_usecase.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc({required this.getPropertiesUseCase}) : super(ExploreInitial()) {
    on<ExploreLoadProperties>(_onLoadProperties);
    on<ExploreSearchChanged>(_onSearchChanged);
    on<ExplorePropertyTapped>(_onPropertyTapped);
    on<ExploreSaveToggled>(_onSaveToggled);
    on<ExploreViewToggled>(_onViewToggled);
  }

  final GetPropertiesUseCase getPropertiesUseCase;

  Future<void> _onLoadProperties(
    ExploreLoadProperties event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoading());
    try {
      final properties = await getPropertiesUseCase();
      emit(ExploreLoaded(
        properties: properties,
        filteredProperties: properties,
        selectedProperty: properties.isNotEmpty ? properties.first : null,
      ));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }

  void _onSearchChanged(
    ExploreSearchChanged event,
    Emitter<ExploreState> emit,
  ) {
    final current = state;
    if (current is! ExploreLoaded) return;

    final query = event.query.toLowerCase();
    final filtered = query.isEmpty
        ? current.properties
        : current.properties.where((p) {
            return p.title.toLowerCase().contains(query) ||
                p.location.toLowerCase().contains(query);
          }).toList();

    emit(current.copyWith(filteredProperties: filtered, searchQuery: query));
  }

  void _onPropertyTapped(
    ExplorePropertyTapped event,
    Emitter<ExploreState> emit,
  ) {
    final current = state;
    if (current is! ExploreLoaded) return;
    emit(current.copyWith(selectedProperty: event.property));
  }

  void _onSaveToggled(
    ExploreSaveToggled event,
    Emitter<ExploreState> emit,
  ) {
    final current = state;
    if (current is! ExploreLoaded) return;

    final updated = current.properties.map((p) {
      return p.id == event.propertyId ? p.copyWith(isSaved: !p.isSaved) : p;
    }).toList();

    final updatedSelected = current.selectedProperty?.id == event.propertyId
        ? current.selectedProperty!
            .copyWith(isSaved: !current.selectedProperty!.isSaved)
        : current.selectedProperty;

    emit(current.copyWith(
      properties: updated,
      filteredProperties: updated,
      selectedProperty: updatedSelected,
    ));
  }

  void _onViewToggled(
    ExploreViewToggled event,
    Emitter<ExploreState> emit,
  ) {
    final current = state;
    if (current is! ExploreLoaded) return;
    emit(current.copyWith(isMapView: !current.isMapView));
  }
}
