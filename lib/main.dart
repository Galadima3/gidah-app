import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:gidah/src/features/auth/presentation/screens/landing_screen.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';
import 'package:gidah/src/features/bookmark/data/bookmark_state_notifier.dart';
import 'package:gidah/src/features/bookmark/presentation/bookmark_screen.dart';
import 'package:gidah/src/features/lodge/presentation/screens/home_screen.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:gidah/src/features/search/presentation/search_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gidah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.urbanist().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1AB65C)),
          useMaterial3: true,
        ),
        home: const AuthChecker()
        //home: const ProfileDetails()
        );
  }
}

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const BottomNavBar();
        } else {
          return const LoginScreen();
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, trace) => const LandingScreen(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    BookmarkScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
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
                           final bookmarkLength =
                          ref.watch(bookmarksStateNotifierProvider);
                return Badge(
                label: Text(bookmarkLength.length.toString()),
                child: const Icon(Icons.bookmark),
              );
              },
              
            ),
            // icon: Stack(
            //   children: [
            //     const Icon(
            //       Icons.bookmark,
            //       size: 30,
            //     ),
            //     Positioned(
            //       top: -2.5,
            //       right: -2.5,
            //       child: Consumer(
            //         builder: (context, ref, child) {
           
            //           return Container(
            //             padding: const EdgeInsets.all(6),
            //             decoration: const BoxDecoration(
            //                 color: Colors.red,
            //                 //borderRadius: BorderRadius.circular(6),
            //                 shape: BoxShape.circle),
            //             constraints: const BoxConstraints(
            //               minWidth: 10,
            //               minHeight: 10,
            //             ),
            //             child: Text(
            //               bookmarkLength.length
            //                   .toString(), // Replace with the actual number of bookmarks
            //               style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 10,
            //               ),
            //               textAlign: TextAlign.center,
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            label: 'Bookmarks',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 5,
      ),
    );
  }
}
