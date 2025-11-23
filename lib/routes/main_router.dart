import 'package:betaversion/core/layout/app_screen.dart';
import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/screens/home/home.dart';
import 'package:go_router/go_router.dart';

final RouteBase mainRouter = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainAppScreen(navigationShell: navigationShell);
  },
  branches: [
    // Home branch
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteConstants.home,
          path: '/app',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),

    // QBank branch
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteConstants.project,
          path: '/app/project',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),

    // Videos branch
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteConstants.search,
          path: '/app/search',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),

    // Profile branch
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteConstants.aboutUs,
          path: '/app/about-us',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
  ],
);
