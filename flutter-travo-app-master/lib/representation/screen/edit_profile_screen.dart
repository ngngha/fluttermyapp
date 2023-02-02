
import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, this.usersModal}) : super(key: key);
  static const String routeName = '/edit_profile_screen';
  final Users? usersModal;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin cá nhân'),
      ),
    );
  }
}
