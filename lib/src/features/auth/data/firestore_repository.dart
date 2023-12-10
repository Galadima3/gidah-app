import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/auth/domain/user_model.dart';

class FirestoreRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadFile(File selectedImage) async {
    // ignore: unnecessary_null_comparison
    if (selectedImage == null) return;
    //final fileName = basename(_selectedImage.path);
    final destination = 'files/${_auth.currentUser?.uid}';

    try {
      final ref = _storage.ref(destination);
      await ref.putFile(selectedImage);
      return await ref.getDownloadURL();
    } catch (e) {
      log('Error occurred: $e');
    }
  }

  Future<void> storeUserDataInFirestore({
    required String email,
    required String dateOfBirth,
    required String fullName,
    required String gender,
    required File profileImage,
    required String phoneNumber,
  }) async {
    String imageUrl = await uploadFile(profileImage);

    try {
      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        'email': email,
        'dateOfBirth': dateOfBirth,
        'fullName': fullName,
        'profileImage': imageUrl,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'time': DateTime.now()
      });
    } catch (e) {
      throw Exception('Failed to store user data in Firestore: $e');
    }
  }

  Future<UserModel?> getLoggedInUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return UserModel.fromMap(data, doc.id);
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
}

//providers
final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository();
});

final userInfoProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  return ref.read(firestoreRepositoryProvider).getLoggedInUserData();
});
