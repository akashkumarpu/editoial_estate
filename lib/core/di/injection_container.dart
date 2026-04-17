import 'package:get_it/get_it.dart';

import '../../features/explore/data/datasources/property_local_datasource.dart';
import '../../features/explore/data/repositories/property_repository_impl.dart';
import '../../features/explore/domain/repositories/property_repository.dart';
import '../../features/explore/domain/usecases/get_properties_usecase.dart';
import '../../features/explore/presentation/bloc/explore_bloc.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/saved/presentation/cubit/saved_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Data Sources ──────────────────────────────────────────────────
  sl.registerLazySingleton<PropertyLocalDatasource>(
    () => PropertyLocalDatasourceImpl(),
  );

  // ── Repositories ──────────────────────────────────────────────────
  sl.registerLazySingleton<PropertyRepository>(
    () => PropertyRepositoryImpl(datasource: sl()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetPropertiesUseCase(sl()));

  // ── BLoCs / Cubits ────────────────────────────────────────────────
  sl.registerFactory(() => ExploreBloc(getPropertiesUseCase: sl()));
  sl.registerFactory(() => SavedCubit(propertyRepository: sl()));
  sl.registerFactory(() => ProfileCubit());
  sl.registerFactory(() => OnboardingCubit());
}
