import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'dashboard/contact_list_screen.dart';
import 'favorites/favorites_screen.dart';
import 'profile/user_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final UserModel user;

  const MainNavigationScreen({
    super.key,
    required this.user,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final PersistentTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PersistentTabConfig> _buildTabs() {
    return [
      PersistentTabConfig(
        screen: ContactListScreen(user: widget.user),
        item: ItemConfig(
          icon: const Icon(Icons.contacts_rounded),
          inactiveIcon: const Icon(Icons.contacts_outlined),
          title: 'Contacts',
          activeForegroundColor: AppTheme.slate900,
          inactiveForegroundColor: AppTheme.slate400,
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: const FavoritesScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.star_rounded),
          inactiveIcon: const Icon(Icons.star_outline_rounded),
          title: 'Favorites',
          activeForegroundColor: AppTheme.slate900,
          inactiveForegroundColor: AppTheme.slate400,
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: UserProfileScreen(user: widget.user),
        item: ItemConfig(
          icon: const Icon(Icons.person_rounded),
          inactiveIcon: const Icon(Icons.person_outline_rounded),
          title: 'Profile',
          activeForegroundColor: AppTheme.slate900,
          inactiveForegroundColor: AppTheme.slate400,
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _tabController,
      tabs: _buildTabs(),
      navBarBuilder: (navBarConfig) => Style3BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: const NavBarDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
        ),
      ),
    );
  }
}
