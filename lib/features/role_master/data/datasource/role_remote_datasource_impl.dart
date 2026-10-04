import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:identity/core/network/endpoints/role_master_endpoints.dart';
import 'package:identity/core/network/models/paginated_response.dart';

import '../models/role_model.dart';
import 'role_remote_datasource.dart';

class RoleRemoteDataSourceImpl implements RoleRemoteDataSource {
  final Dio dio;

  RoleRemoteDataSourceImpl({required this.dio});

  @override
  Future<RoleModel> createRole(Map<String, dynamic> requestData) async {
    debugPrint('DEBUG [RoleRemoteDataSource]: Creating role');

    final response = await dio.post(
      RoleMasterEndpoints.createRole,
      data: requestData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('DEBUG [RoleRemoteDataSource]: Role created successfully');
      return RoleModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create role. Status: ${response.statusCode}');
    }
  }

  @override
  Future<PaginatedResponse<RoleModel>> getRoles({
    required int page,
    required int size,
    String? search,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'size': size};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await dio.get(
      RoleMasterEndpoints.list,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedResponse<RoleModel>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => RoleModel.fromJson(json as Map<String, dynamic>),
      );
    } else {
      throw Exception('Failed to fetch roles. Status: ${response.statusCode}');
    }
  }

  @override
  Future<RoleModel> getRoleById(String id) async {
    debugPrint('DEBUG [RoleRemoteDataSource]: Fetching role by id: $id');

    final response = await dio.get(RoleMasterEndpoints.getRoleById(id));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('DEBUG [RoleRemoteDataSource]: Role fetched successfully');
      return RoleModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch role. Status: ${response.statusCode}');
    }
  }

  @override
  Future<RoleModel> updateRole(
    String id,
    Map<String, dynamic> requestData,
  ) async {
    final response = await dio.put(
      RoleMasterEndpoints.updateRole(id),
      data: requestData,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.statusCode == 204 ||
          response.data == null ||
          response.data.toString().isEmpty) {
        return RoleModel(
          id: id,
          name: requestData['name'] ?? '',
          description: requestData['description'] ?? '',
          status: requestData['status'] ?? '',
        );
      }
      return RoleModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update role. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> activateRole(String id) async {
    final response = await dio.post(RoleMasterEndpoints.activateRole(id));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to activate role. Status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deactivateRole(String id) async {
    final response = await dio.post(RoleMasterEndpoints.deactivateRole(id));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to deactivate role. Status: ${response.statusCode}',
      );
    }
  }
}
