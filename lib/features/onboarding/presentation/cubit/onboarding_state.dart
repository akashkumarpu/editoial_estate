part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.isCompleted = false,
  });

  final int currentPage;
  final bool isCompleted;

  OnboardingState copyWith({int? currentPage, bool? isCompleted}) =>
      OnboardingState(
        currentPage: currentPage ?? this.currentPage,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  @override
  List<Object?> get props => [currentPage, isCompleted];
}
