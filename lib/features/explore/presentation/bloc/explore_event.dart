part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object?> get props => [];
}

class ExploreLoadProperties extends ExploreEvent {
  const ExploreLoadProperties();
}

class ExploreSearchChanged extends ExploreEvent {
  const ExploreSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class ExplorePropertyTapped extends ExploreEvent {
  const ExplorePropertyTapped(this.property);
  final Property property;
  @override
  List<Object?> get props => [property.id];
}

class ExploreSaveToggled extends ExploreEvent {
  const ExploreSaveToggled(this.propertyId);
  final String propertyId;
  @override
  List<Object?> get props => [propertyId];
}

class ExploreViewToggled extends ExploreEvent {
  const ExploreViewToggled();
}
