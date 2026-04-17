part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreError extends ExploreState {
  const ExploreError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ExploreLoaded extends ExploreState {
  const ExploreLoaded({
    required this.properties,
    required this.filteredProperties,
    this.selectedProperty,
    this.searchQuery = '',
    this.isMapView = true,
  });

  final List<Property> properties;
  final List<Property> filteredProperties;
  final Property? selectedProperty;
  final String searchQuery;
  final bool isMapView;

  ExploreLoaded copyWith({
    List<Property>? properties,
    List<Property>? filteredProperties,
    Property? selectedProperty,
    String? searchQuery,
    bool? isMapView,
  }) =>
      ExploreLoaded(
        properties: properties ?? this.properties,
        filteredProperties: filteredProperties ?? this.filteredProperties,
        selectedProperty: selectedProperty ?? this.selectedProperty,
        searchQuery: searchQuery ?? this.searchQuery,
        isMapView: isMapView ?? this.isMapView,
      );

  @override
  List<Object?> get props =>
      [properties, filteredProperties, selectedProperty, searchQuery, isMapView];
}
