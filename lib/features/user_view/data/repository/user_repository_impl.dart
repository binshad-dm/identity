import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_detail_entity.dart';
import '../../domain/entities/create_user_request.dart';
import '../../domain/entities/update_user_request.dart';
import '../../domain/entities/role_select_item.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<UserEntity>>> getUsers({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await remoteDataSource.getUsers(
        search: search,
        role: role,
        status: status,
        page: page,
        size: size,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailEntity>> getUserDetail(String id) async {
    try {
      final result = await remoteDataSource.getUserDetail(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUser(
    CreateUserRequest request,
  ) async {
    try {
      final result = await remoteDataSource.createUser(request.toJson());
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String id,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.changePassword(id, oldPassword, newPassword);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
    UpdateUserRequest request,
  ) async {
    try {
      final result = await remoteDataSource.updateUser(
        request.id,
        request.toJson(),
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure(
        'Connection timed out. Please check your internet.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection.');
    } else if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return const AuthFailure('Unauthorized access. Please login again.');
    } else if (e.response?.statusCode == 404) {
      return const NotFoundFailure(
        'The selected user account no longer exists or is unavailable.',
      );
    } else if (e.response?.statusCode != null) {
      // The backend returns validation errors in the 'detail' field
      // (e.g. { "title": "VALIDATION_ERROR", "detail": "Invalid phone number format" }).
      // Fall back to 'message', then to a generic string.
      final data = e.response?.data;
      String message = 'Server error occurred.';
      if (data is Map) {
        message = data['detail']?.toString().trim().isNotEmpty == true
            ? data['detail'].toString()
            : data['message']?.toString().trim().isNotEmpty == true
            ? data['message'].toString()
            : 'Server error occurred.';
      }
      return ServerFailure(message);
    }
    return UnknownFailure('An unexpected error occurred.');
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String id,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.resetPassword(id, newPassword);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> activateUser(String id) async {
    try {
      await remoteDataSource.activateUser(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateUser(String id) async {
    debugPrint('DEBUG [UserRepositoryImpl]: deactivateUser called for $id');
    try {
      await remoteDataSource.deactivateUser(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoleSelectItem>>> getRolesSelect() async {
    try {
      final result = await remoteDataSource.getRolesSelect();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRoles(
    String id,
    List<String> roles,
  ) async {
    try {
      await remoteDataSource.updateUserRoles(id, roles);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
