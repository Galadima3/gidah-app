// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AuthState {
//   final User? user;

//   AuthState(this.user);
// }

// class AuthStateNotifier extends StateNotifier<AuthState> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   AuthStateNotifier() : super(AuthState(null));

//   Stream get isUserSignedIn => _auth.authStateChanges();

//   Future<void> signUp(String email, String password) async {
//     try {
//       final result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       state = AuthState(result.user);
//     } on FirebaseAuthException catch (e) {
//       throw AuthException(e.message ?? 'An error occurred during sign-up.');
//     }
//   }

//   Future<void> signIn(String email, String password) async {
//     try {
//       final result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       state = AuthState(result.user);
//     } on FirebaseAuthException catch (e) {
//       throw AuthException(e.message ?? 'An error occurred during sign-in.');
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     state = AuthState(null);
//   }

//   Future<void> resetPassword({required String email}) async {
//     await _auth.sendPasswordResetEmail(email: email);
//   }
// }

// class AuthException implements Exception {
//   final String message;

//   AuthException(this.message);

//   @override
//   String toString() {
//     return message;
//   }
// }

// //Providers
// final authStateNotifierProvider =
//     StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
//   return AuthStateNotifier();
// });

// final userProvider = Provider<User?>((ref) {
//   final authState = ref.watch(authStateNotifierProvider);
//   return authState.user;
// });

// final authStateProvider = StreamProvider((ref) async* {
//   yield ref.read(authStateNotifierProvider.notifier).isUserSignedIn;
// });
