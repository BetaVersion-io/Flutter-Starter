import 'package:betaversion/core/storage/secure_storage.dart';
import 'package:betaversion/features/auth/data/services/auth_api_service.dart';
import 'package:betaversion/features/auth/domain/models/auth_response.dart';
import 'package:betaversion/features/auth/domain/models/login_request.dart';
import 'package:betaversion/features/auth/domain/models/register_request.dart';
import 'package:betaversion/features/auth/domain/models/update_profile_request.dart';
import 'package:betaversion/features/auth/domain/models/user.dart';
import 'package:betaversion/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<AuthResponse> login(
    LoginRequest request, {
    CancelToken? cancelToken,
  }) async {
    final responseDto = await _apiService.login(
      request,
      cancelToken: cancelToken,
    );

    final authResponse = responseDto.toDomain();

    // Save tokens after successful login
    await saveAuthTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    // Save user ID
    await SecureStorage.saveUserId(authResponse.user.id);

    return authResponse;
  }

  @override
  Future<AuthResponse> register(
    RegisterRequest request, {
    CancelToken? cancelToken,
  }) async {
    final responseDto = await _apiService.register(
      request,
      cancelToken: cancelToken,
    );

    final authResponse = responseDto.toDomain();

    // Save tokens after successful registration
    await saveAuthTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    // Save user ID
    await SecureStorage.saveUserId(authResponse.user.id);

    return authResponse;
  }

  @override
  Future<User> updateProfile(
    UpdateProfileRequest request, {
    CancelToken? cancelToken,
  }) async {
    final userDto = await _apiService.updateProfile(
      request,
      cancelToken: cancelToken,
    );

    return userDto.toDomain();
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {
    try {
      await _apiService.logout(cancelToken: cancelToken);
    } finally {
      // Always clear local tokens, even if API call fails
      await clearAuthTokens();
    }
  }

  @override
  Future<void> deleteAccount({CancelToken? cancelToken}) async {
    try {
      await _apiService.deleteAccount(cancelToken: cancelToken);
    } finally {
      // Always clear local tokens
      await clearAuthTokens();
    }
  }

  @override
  Future<User> getCurrentUser({CancelToken? cancelToken}) async {
    final userDto = await _apiService.getCurrentUser(cancelToken: cancelToken);

    return userDto.toDomain();
  }

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await SecureStorage.saveAuthToken(accessToken);
    if (refreshToken != null) {
      await SecureStorage.saveRefreshToken(refreshToken);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return SecureStorage.getAuthToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return SecureStorage.getRefreshToken();
  }

  @override
  Future<void> clearAuthTokens() async {
    await SecureStorage.clearAuthTokens();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
