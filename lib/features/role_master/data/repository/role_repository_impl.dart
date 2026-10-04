import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import '../../domain/entities/create_role_request.dart';
import '../datasource/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RoleEntity>> createRole(
    CreateRoleRequest request,
  ) async {
    try {
      final result = await remoteDataSource.createRole(request.toJson());
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<RoleEntity>>> getRoles({
    required int page,
    required int size,
    String? search,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getRoles(
        page: page,
        size: size,
        search: search,
        status: status,
      );

      return Right(
        PaginatedResponse<RoleEntity>(
          content: result.content,
          totalElements: result.totalElements,
          totalPages: result.totalPages,
          size: result.size,
          number: result.number,
        ),
      );
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> getRoleById(String id) async {
    try {
      final result = await remoteDataSource.getRoleById(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleEntity>> updateRole(
    String id,
    CreateRoleRequest request,
  ) async {
    try {
      final result = await remoteDataSource.updateRole(id, request.toJson());
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> activateRole(String id) async {
    try {
      await remoteDataSource.activateRole(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateRole(String id) async {
    try {
      await remoteDataSource.deactivateRole(id);
      return const Right(null);
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
      return const NotFoundFailure('The selected resource was not found.');
    } else if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final detail = data['detail'];
        final msg = data['message'];

        final combinedStr = '${detail?.toString()} ${msg?.toString()}'
            .toLowerCase();
        if (combinedStr.contains('already exists')) {
          return const ServerFailure('Role name already exists.');
        }

        if (detail != null) return ServerFailure(detail.toString());
        if (msg != null) return ServerFailure(msg.toString());
      }
      return const ServerFailure(
        'Invalid request. Please check the provided data.',
      );
    } else if (e.response?.statusCode != null) {
      final data = e.response?.data;
      String message = 'Server error occurred.';
      if (data is Map<String, dynamic>) {
        message =
            data['message']?.toString() ??
            data['detail']?.toString() ??
            message;
      }
      return ServerFailure(message);
    }
    return UnknownFailure('An unexpected error occurred.');
  }
}
