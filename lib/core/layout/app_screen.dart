import 'package:betaversion/core/layout/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

final _routes = [
  RouteConstants.home,
  RouteConstants.project,
  RouteConstants.search,
  RouteConstants.aboutUs,
];

class MainAppScreen extends HookWidget {
  final StatefulNavigationShell navigationShell;

  const MainAppScreen({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(
      initialPage: navigationShell.currentIndex,
    );

    final lastNavIndex = useState(navigationShell.currentIndex);

    // Sync PageView with NavigationShell changes (from external navigation)
    useEffect(() {
      void syncToPageView() {
        final newIndex = navigationShell.currentIndex;

        if (newIndex != lastNavIndex.value && pageController.hasClients) {
          lastNavIndex.value = newIndex;

          // Use post frame callback to ensure smooth updates
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (pageController.hasClients) {
              pageController.jumpToPage(newIndex);
            }
          });
        }
      }

      syncToPageView();
      return null;
    }, [navigationShell.currentIndex]);

    // Handle PageView page changes (user swiping)
    void onPageChanged(int index) {
      lastNavIndex.value = index;

      if (index < _routes.length) {
        context.goNamed(_routes[index]);
      }
    }

    // Handle bottom nav taps
    void onTabTapped(int index) {
      if (index == lastNavIndex.value) return;
      lastNavIndex.value = index;

      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }

      if (index < _routes.length) {
        context.goNamed(_routes[index]);
      }
    }

    return AppScaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex:
            lastNavIndex.value, // Use local state instead of navigationShell
        onTap: onTabTapped,
      ),
    );
  }
}
