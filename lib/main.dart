import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:gidah/src/features/auth/presentation/screens/landing_screen.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';
import 'package:gidah/src/features/auth/presentation/widgets/bottom_navigation_bar.dart';

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
  const AuthChecker({super.key});

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

