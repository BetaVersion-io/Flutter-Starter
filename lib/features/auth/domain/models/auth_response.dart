import 'package:betaversion/features/auth/domain/models/user.dart';
import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final User user;
  final String accessToken;
  final String? refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
