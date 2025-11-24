import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/screens/auth/login.dart';
import 'package:betaversion/screens/auth/register.dart';
import 'package:go_router/go_router.dart';

/// Authentication routes
///
/// Includes login, register, and other authentication-related screens
final authRoutes = [
  GoRoute(
    name: RouteConstants.login,
    path: '/auth/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: RouteConstants.register,
    path: '/auth/register',
    builder: (context, state) => const RegisterScreen(),
  ),
];
