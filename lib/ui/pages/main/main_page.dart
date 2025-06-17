import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigsaw_client/core/router/build_route.dart';
import 'package:jigsaw_client/ui/pages/debug/debug_panel.dart';
import 'package:jigsaw_client/ui/pages/main/destinations/project_view.dart';
import 'package:jigsaw_client/ui/pages/users/users_page.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/user_provider.dart';
import 'package:jigsaw_client/ui/providers/session_provider.dart';
import 'package:jigsaw_client/ui/widgets/profile_button.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  final destinations = [ProjectView()];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: destinations.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          'assets/jigsaw_icon_adaptive.svg',

          color: Theme.of(context).colorScheme.primary,
          width: 48,
          height: 48,
        ),
        title: Text('Jigsaw'),
        actions: [
          userData.isLoading
              ? SizedBox()
              : userData.error != null
              ? SizedBox()
              : userData.data!.nickname != "root"
              ? SizedBox()
              : IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                      UserManagementPage(),
                      RouteSettings(name: "/users"),
                    ),
                  );
                },
                icon: Icon(Icons.add_reaction_outlined),
              ),
          if (kDebugMode)
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    DebugPanel(),
                    RouteSettings(name: '/debug-panel'),
                  ),
                );
              },
              child: Text('Debug Panel'),
            ),
          SizedBox(width: 8),
          ProfileButton(),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              ref.read(sessionProvider.notifier).state = null;
              // ref.watch(authRepositoryProvider).logout();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (v) {
              setState(() {
                selectedIndex = v;
              });
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
            ],
            selectedIndex: selectedIndex,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: destinations,
            ),
          ),
        ],
      ),
    );
  }
}
