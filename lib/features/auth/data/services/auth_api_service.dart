import 'package:betaversion/features/auth/data/dtos/auth_response_dto.dart';
import 'package:betaversion/features/auth/data/dtos/user_dto.dart';
import 'package:betaversion/features/auth/data/services/auth_api_endpoint.dart';
import 'package:betaversion/features/auth/domain/models/login_request.dart';
import 'package:betaversion/features/auth/domain/models/register_request.dart';
import 'package:betaversion/features/auth/domain/models/update_profile_request.dart';
import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  /// Login with email and password
  Future<AuthResponseDto> login(
    LoginRequest request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post(
      AuthApiEndpoint.login,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return AuthResponseDto.fromJson(response.data);
  }

  /// Register a new user
  Future<AuthResponseDto> register(
    RegisterRequest request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post(
      AuthApiEndpoint.register,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return AuthResponseDto.fromJson(response.data);
  }

  /// Update user profile
  Future<UserDto> updateProfile(
    UpdateProfileRequest request, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.put(
      AuthApiEndpoint.editProfile,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    return UserDto.fromJson(response.data);
  }

  /// Logout current user
  Future<void> logout({CancelToken? cancelToken}) async {
    await _dio.post(AuthApiEndpoint.logout, cancelToken: cancelToken);
  }

  /// Delete user account
  Future<void> deleteAccount({CancelToken? cancelToken}) async {
    await _dio.delete(AuthApiEndpoint.deleteAccount, cancelToken: cancelToken);
  }

  /// Get current user profile
  Future<UserDto> getCurrentUser({CancelToken? cancelToken}) async {
    final response = await _dio.get(
      AuthApiEndpoint.editProfile,
      cancelToken: cancelToken,
    );

    return UserDto.fromJson(response.data);
  }
}
