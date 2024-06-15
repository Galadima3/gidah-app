import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/bookmark/data/bookmark_state_notifier.dart';
import 'package:gidah/src/features/bookmark/presentation/bookmark_screen.dart';
import 'package:gidah/src/features/lodge/presentation/screens/home_screen.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:gidah/src/features/search/presentation/search_screen.dart';

final bottomNavbarIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bookmarkLength = ref.watch(bookmarksStateNotifierProvider).length;
    final bottomNavbarIndex = ref.watch(bottomNavbarIndexProvider);

    return Scaffold(
      body: Center(child: _pages[bottomNavbarIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, child) {
                return Badge(
                  label: Text(bookmarkLength.toString()),
                  child: const Icon(Icons.bookmark),
                );
              },
            ),
            label: 'Bookmarks',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: bottomNavbarIndex,
        onTap: (value) => ref
            .read(bottomNavbarIndexProvider.notifier)
            .update((state) => value),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 5,
      ),
    );
  }
}
