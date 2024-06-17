import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:gidah/src/features/auth/presentation/screens/landing_screen.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';
import 'package:gidah/src/features/auth/presentation/widgets/bottom_navigation_bar.dart';

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

