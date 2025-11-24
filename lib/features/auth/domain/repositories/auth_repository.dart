import 'package:dio/dio.dart';

import 'package:betaversion/features/auth/domain/models/auth_response.dart';
import 'package:betaversion/features/auth/domain/models/login_request.dart';
import 'package:betaversion/features/auth/domain/models/register_request.dart';
import 'package:betaversion/features/auth/domain/models/update_profile_request.dart';
import 'package:betaversion/features/auth/domain/models/user.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResponse> login(
    LoginRequest request, {
    CancelToken? cancelToken,
  });

  /// Register a new user
  Future<AuthResponse> register(
    RegisterRequest request, {
    CancelToken? cancelToken,
  });

  /// Update user profile
  Future<User> updateProfile(
    UpdateProfileRequest request, {
    CancelToken? cancelToken,
  });

  /// Logout current user
  Future<void> logout({CancelToken? cancelToken});

  /// Delete user account
  Future<void> deleteAccount({CancelToken? cancelToken});

  /// Get current user profile
  Future<User> getCurrentUser({CancelToken? cancelToken});

  /// Save authentication tokens locally
  Future<void> saveAuthTokens({
    required String accessToken,
    String? refreshToken,
  });

  /// Get saved access token
  Future<String?> getAccessToken();

  /// Get saved refresh token
  Future<String?> getRefreshToken();

  /// Clear authentication tokens
  Future<void> clearAuthTokens();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
