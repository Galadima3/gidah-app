import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String dateOfBirth;
  final String fullName;
  final String gender;
  final String profileImage;
  final String phoneNumber;
  final DateTime time;

  UserModel({
    required this.id,
    required this.email,
    required this.dateOfBirth,
    required this.fullName,
    required this.gender,
    required this.profileImage,
    required this.phoneNumber,
    required this.time,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      fullName: data['fullName'] ?? '',
      gender: data['gender'] ?? '',
      profileImage: data['profileImage'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      time: (data['time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'dateOfBirth': dateOfBirth,
      'fullName': fullName,
      'gender': gender,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'time': time,
    };
  }
}
