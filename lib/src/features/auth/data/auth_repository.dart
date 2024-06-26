import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  const AuthRepository(this._auth);
  final FirebaseAuth _auth;

  //getters
  User? get userDetails => _auth.currentUser;
  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('Sign in successful');
      return result.user;
    } on FirebaseAuthException catch (e) {
      final errorMessages = {
        'user-not-found': 'User not found',
        'wrong-password': 'Wrong password',
        'invalid-credential': 'Check your email/password and try again',
      };
      final errorMessage =
          errorMessages[e.code] ?? e.message ?? 'An unknown error occurred';
      log(errorMessage);
      throw AuthException(errorMessage);
    } catch (e) {
      log('An unexpected error occurred: $e');
      throw AuthException('An unexpected error occurred');
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log('Sign up successful');
      return result.user;
    } on FirebaseAuthException catch (e) {
      final errorMessages = {
        'email-in-use': 'Email already in use',
      };
      final errorMessage =
          errorMessages[e.code] ?? e.message ?? 'An unknown error occurred';
      log(errorMessage);
      throw AuthException(errorMessage);
    }
  }

  //sign out method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //password reset
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

//Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChange;
});

final userDetailsProvider = FutureProvider.autoDispose<User?>((ref) {
  return ref.read(authRepositoryProvider).userDetails;
});
