import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'data/datasource/role_remote_datasource.dart';
import 'data/datasource/role_remote_datasource_impl.dart';
import 'data/repository/role_repository_impl.dart';
import 'domain/repositories/role_repository.dart';
import 'domain/usecases/create_role_use_case.dart';
import 'domain/usecases/get_roles_usecase.dart';
import 'domain/usecases/get_role_by_id_usecase.dart';

import 'domain/usecases/update_role_use_case.dart';
import 'domain/usecases/activate_role_use_case.dart';
import 'domain/usecases/deactivate_role_use_case.dart';

void initRoleMasterInjection(GetIt sl) {
  // DataSource
  sl.registerLazySingleton<RoleRemoteDataSource>(
    () => RoleRemoteDataSourceImpl(dio: sl<Dio>(instanceName: 'roleDio')),
  );

  // Repository
  sl.registerLazySingleton<RoleRepository>(
    () => RoleRepositoryImpl(sl<RoleRemoteDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton<CreateRoleUseCase>(
    () => CreateRoleUseCase(sl<RoleRepository>()),
  );
  sl.registerLazySingleton<GetRolesUseCase>(
    () => GetRolesUseCase(sl<RoleRepository>()),
  );
  sl.registerLazySingleton<GetRoleByIdUseCase>(
    () => GetRoleByIdUseCase(sl<RoleRepository>()),
  );
  sl.registerLazySingleton<UpdateRoleUseCase>(
    () => UpdateRoleUseCase(sl<RoleRepository>()),
  );
  sl.registerLazySingleton<ActivateRoleUseCase>(
    () => ActivateRoleUseCase(sl<RoleRepository>()),
  );
  sl.registerLazySingleton<DeactivateRoleUseCase>(
    () => DeactivateRoleUseCase(sl<RoleRepository>()),
  );
}
