import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/profile/domain/profile_model.dart';

class ProfileFirestoreRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileModel?> getLoggedInUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return ProfileModel.fromMap(data, doc.id);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching user data from Firestore: $e');
      return null;
    }
  }

  Future<void> updateProfileData({
    required String fullName,
    required String dateOfBirth,
    required String email,
    required String phoneNumber,
    required String gender,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'dateOfBirth': dateOfBirth,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'gender': gender,
          'time': DateTime.now()
        });
      }
    } catch (e) {
      log('Error updating user data in Firestore: $e');
    }
  }
}

final rex = Provider<ProfileFirestoreRepository>((ref) {
  return ProfileFirestoreRepository();
});

final profileInfoProvider =
    FutureProvider.autoDispose<ProfileModel?>((ref) async {
  return ref.read(rex).getLoggedInUserData();
});
