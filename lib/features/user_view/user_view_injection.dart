import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'data/datasource/user_remote_datasource.dart';
import 'data/datasource/user_remote_datasource_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/fetch_users_use_case.dart';
import 'domain/usecases/get_user_detail_use_case.dart';
import 'domain/usecases/create_user_use_case.dart';
import 'domain/usecases/change_password_use_case.dart';
import 'domain/usecases/update_user_use_case.dart';

void initUserViewInjection(GetIt sl) {
  // DataSource — uses the dedicated port-8081 Dio instance
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl<Dio>(instanceName: 'userDio')),
  );

  // Repository — lazy singletond
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
  );

  // UseCases — lazy singletons
  sl.registerLazySingleton<FetchUsersUseCase>(
    () => FetchUsersUseCase(repository: sl<UserRepository>()),
  );

  sl.registerLazySingleton<GetUserDetailUseCase>(
    () => GetUserDetailUseCase(repository: sl<UserRepository>()),
  );

  sl.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(sl<UserRepository>()),
  );

  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl<UserRepository>()),
  );

  sl.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(sl<UserRepository>()),
  );

  // Cubit is NOT registered globally here — it is created as a factory
  // directly inside UserListPage via BlocProvider so its lifetime is scoped
  // to the page. The page pulls use cases from sl<> on demand.
}
