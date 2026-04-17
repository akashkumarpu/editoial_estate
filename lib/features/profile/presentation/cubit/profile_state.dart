part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user, required this.isDarkMode});

  final UserEntity user;
  final bool isDarkMode;

  ProfileLoaded copyWith({UserEntity? user, bool? isDarkMode}) => ProfileLoaded(
        user: user ?? this.user,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );

  @override
  List<Object?> get props => [user, isDarkMode];
}

class ProfileLoggedOut extends ProfileState {}
