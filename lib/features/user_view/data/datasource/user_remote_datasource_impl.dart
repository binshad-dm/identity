import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:identity/core/network/endpoints/user_endpoints.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../models/user_model.dart';
import '../models/user_detail_model.dart';
import '../../domain/entities/role_select_item.dart';
import 'user_remote_datasource.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedResponse<UserModel>> getUsers({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int size = 10,
  }) async {
    debugPrint(
      'DEBUG [UserRemoteDataSource]: Fetching users — page $page, size $size, search "$search"',
    );

    final queryParameters = <String, dynamic>{
      'page': page,
      'size': size,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (role != null && role.trim().isNotEmpty) 'role': role.trim(),
      if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
    };

    final response = await dio.get(
      UserEndpoints.list,
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      debugPrint(
        'DEBUG [UserRemoteDataSource]: Response received — ${response.data}',
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
    } else {
      throw Exception('Failed to load users. Status: ${response.statusCode}');
    }
  }

  @override
  Future<UserDetailModel> getUserDetail(String id) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Fetching user detail — id $id');

    final response = await dio.get(UserEndpoints.getById(id));

    if (response.statusCode == 200) {
      debugPrint(
        'DEBUG [UserRemoteDataSource]: User detail received — ${response.data}',
      );
      return UserDetailModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception(
        'Failed to load user detail. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> requestData) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Creating user');

    final response = await dio.post(
      UserEndpoints.createUser,
      data: requestData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('DEBUG [UserRemoteDataSource]: User created successfully');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create user. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> changePassword(
    String id,
    String oldPassword,
    String newPassword,
  ) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Changing password for user $id');

    final response = await dio.post(
      UserEndpoints.changePassword(id),
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(
        'DEBUG [UserRemoteDataSource]: Password changed successfully for $id',
      );
    } else {
      throw Exception(
        'Failed to change password. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<UserModel> updateUser(
    String id,
    Map<String, dynamic> requestData,
  ) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Updating user — id $id');

    final response = await dio.put(
      UserEndpoints.updateUser(id),
      data: requestData,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      debugPrint('DEBUG [UserRemoteDataSource]: User updated successfully');
      // Some backends return 204 No Content; fall back to the request data if so.
      if (response.data != null && response.data is Map) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      return UserModel.fromJson(requestData);
    } else {
      throw Exception('Failed to update user. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> resetPassword(String id, String newPassword) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Resetting password for $id');
    final response = await dio.post(
      UserEndpoints.resetPassword(id),
      data: {'newPassword': newPassword},
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to reset password. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> activateUser(String id) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Activating user $id');
    final response = await dio.post(UserEndpoints.activate(id));

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to activate user. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deactivateUser(String id) async {
    debugPrint('DEBUG [UserRemoteDataSource]: Deactivating user $id');
    final response = await dio.post(UserEndpoints.deactivate(id));

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to deactivate user. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<RoleSelectItem>> getRolesSelect() async {
    debugPrint('DEBUG [UserRemoteDataSource]: Fetching roles select list');
    final response = await dio.get(UserEndpoints.rolesSelect);

    if (response.statusCode == 200) {
      final List data = response.data as List;
      return data
          .map((e) => RoleSelectItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load roles select list. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> updateUserRoles(String id, List<String> roles) async {
    debugPrint(
      'DEBUG [UserRemoteDataSource]: Updating roles for user $id to $roles',
    );
    final response = await dio.put(
      UserEndpoints.updateUserRoles(id),
      data: {'roles': roles},
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to update user roles. Status: ${response.statusCode}',
      );
    }
  }
}
