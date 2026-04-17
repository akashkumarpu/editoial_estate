part of 'property_detail_cubit.dart';

abstract class PropertyDetailState extends Equatable {
  const PropertyDetailState();
  @override
  List<Object?> get props => [];
}

class PropertyDetailLoading extends PropertyDetailState {}

class PropertyDetailLoaded extends PropertyDetailState {
  const PropertyDetailLoaded({required this.property});
  final Property property;
  @override
  List<Object?> get props => [property];
}

class PropertyDetailError extends PropertyDetailState {
  const PropertyDetailError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
