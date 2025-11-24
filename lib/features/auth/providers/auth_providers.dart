import 'package:betaversion/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:betaversion/features/auth/data/services/auth_api_service.dart';
import 'package:betaversion/features/auth/domain/repositories/auth_repository.dart';
import 'package:betaversion/services/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for AuthApiService
///
/// Creates an instance of AuthApiService with the configured Dio client.
/// This service handles all HTTP communication with the authentication API.
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthApiService(dio);
});

/// Provider for AuthRepository
///
/// Creates an instance of AuthRepositoryImpl with the AuthApiService.
/// This repository implements the authentication business logic and
/// coordinates between the API service and local storage.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(authApiServiceProvider);
  return AuthRepositoryImpl(apiService);
});

/// Provider to check if user is authenticated
///
/// Returns true if the user has a valid authentication token stored locally.
/// This provider automatically refreshes whenever the authentication state changes.
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.isAuthenticated();
});

/// Provider to get the current access token
///
/// Returns the stored access token if available, null otherwise.
/// Useful for debugging or checking token status.
final accessTokenProvider = FutureProvider<String?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getAccessToken();
});
