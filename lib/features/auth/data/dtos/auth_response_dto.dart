import 'package:betaversion/features/auth/data/dtos/user_dto.dart';
import 'package:betaversion/features/auth/domain/models/auth_response.dart';

class AuthResponseDto {
  final UserDto user;
  final String accessToken;
  final String? refreshToken;

  AuthResponseDto({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      user: UserDto.fromJson(json['user'] ?? {}),
      accessToken:
          json['access_token']?.toString() ?? json['token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
    };
  }

  AuthResponse toDomain() {
    return AuthResponse(
      user: user.toDomain(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
