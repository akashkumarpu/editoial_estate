import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoaded(user: _mockUser, isDarkMode: false));

  static const _mockUser = UserEntity(
    id: 'u1',
    name: 'Julian H. Sterling',
    subtitle: 'Premier Curator since 2022',
    avatarUrl:
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200&q=80',
    savedCount: 12,
    postedCount: 2,
    searchCount: 5,
    isPremium: false,
  );

  void toggleDarkMode() {
    final current = state;
    if (current is ProfileLoaded) {
      emit(current.copyWith(isDarkMode: !current.isDarkMode));
    }
  }

  void upgradeToPremium() {
    final current = state;
    if (current is ProfileLoaded) {
      emit(current.copyWith(
        user: current.user.copyWith(isPremium: true),
      ));
    }
  }

  void logout() => emit(ProfileLoggedOut());
}
