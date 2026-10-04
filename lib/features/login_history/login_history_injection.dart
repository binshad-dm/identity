import 'package:get_it/get_it.dart';
import '../../core/network/auth_api.dart';
import '../../core/network/token_manager.dart';
import 'data/datasources/login_history_remote_data_source.dart';
import 'data/datasources/login_history_remote_data_source_impl.dart';
import 'data/repositories/login_history_repository_impl.dart';
import 'domain/repositories/login_history_repository.dart';
import 'presentation/view_model/login_history_cubit.dart';

void initLoginHistoryInjection(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<LoginHistoryRemoteDataSource>(
    () => LoginHistoryRemoteDataSourceImpl(sl<AuthApi>()),
  );

  // Repository
  sl.registerLazySingleton<LoginHistoryRepository>(
    () => LoginHistoryRepositoryImpl(
      sl<LoginHistoryRemoteDataSource>(),
      sl<TokenManager>(),
    ),
  );

  // Cubit (Factory)
  sl.registerFactory<LoginHistoryCubit>(
    () => LoginHistoryCubit(
      repository: sl<LoginHistoryRepository>(),
    ),
  );
}
