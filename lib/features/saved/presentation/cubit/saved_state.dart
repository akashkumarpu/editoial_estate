part of 'saved_cubit.dart';

abstract class SavedState extends Equatable {
  const SavedState();
  @override
  List<Object?> get props => [];
}

class SavedInitial extends SavedState {}
class SavedLoading extends SavedState {}

class SavedLoaded extends SavedState {
  const SavedLoaded({required this.properties});
  final List<Property> properties;
  @override
  List<Object?> get props => [properties];
}

class SavedError extends SavedState {
  const SavedError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
