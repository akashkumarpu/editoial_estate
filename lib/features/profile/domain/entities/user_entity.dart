import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.savedCount,
    required this.postedCount,
    required this.searchCount,
    required this.isPremium,
  });

  final String id;
  final String name;
  final String subtitle;
  final String avatarUrl;
  final int savedCount;
  final int postedCount;
  final int searchCount;
  final bool isPremium;

  UserEntity copyWith({
    int? savedCount,
    int? postedCount,
    int? searchCount,
    bool? isPremium,
  }) =>
      UserEntity(
        id: id,
        name: name,
        subtitle: subtitle,
        avatarUrl: avatarUrl,
        savedCount: savedCount ?? this.savedCount,
        postedCount: postedCount ?? this.postedCount,
        searchCount: searchCount ?? this.searchCount,
        isPremium: isPremium ?? this.isPremium,
      );

  @override
  List<Object?> get props => [id, savedCount, postedCount, isPremium];
}
