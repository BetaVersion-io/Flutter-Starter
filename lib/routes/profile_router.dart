import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/screens/profile/profile.dart';
import 'package:go_router/go_router.dart';

final profileRoutes = [
  GoRoute(
    name: RouteConstants.profile,
    path: '/profile',
    builder: (context, state) => const ProfileScreen(),
  ),
];
