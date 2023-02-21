import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String email;
  String detail;
  String gender;
  String phoneNumber;
  // DateTime? dateOfBirth
  // String position;
  // bool canEdit = true;
  UserModel(
      {this.id = '',
      this.username = '',
      this.email = '',
      this.detail = '',
      this.gender = '',
      this.phoneNumber = '',
      // this.level = '',
      });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'detail': detail,
        'gender': gender,
        'phoneNumber': phoneNumber ,
        // 'dateOfBirth': dateOfBirth ,
        // 'level': level,
      };
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        detail: json['detail'],
        gender: json['gender'],
        phoneNumber: json['phoneNumber'],
        // dateOfBirth: (json['dateOfBirth']  as Timestamp).toDate(),
        // level: json['level'],
      );
}
