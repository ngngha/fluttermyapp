import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/dimension_constants.dart';
import 'package:travo_app_source/core/helpers/asset_helper.dart';
import 'package:travo_app_source/core/helpers/image_helper.dart';
import 'package:travo_app_source/data/model/user_model.dart';
import 'package:travo_app_source/representation/screen/edit_profile_screen.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.usersModal}) : super(key: key);
  static const String routeName = '/profile_screen';
  final Users? usersModal;
  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang cá nhân'),
        actions: widget.usersModal == null
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProfileScreen.routeName);
                  },
                  icon: Icon(Icons.edit),
                )
              ]
            : null,
      ),
      body: StreamBuilder<List<Users>>(
        stream: readProject(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final projects = snapshot.data!;
            return ListView(
              children: projects.map(buildProject).toList(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Stream<List<Users>> readProject() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());
  Widget buildProject(Users users) => Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: ImageHelper.loadFromAsset(
              AssetHelper.person,
            ),
          ),
          Text(users.username,
              style: TextStyle(
                color: Colors.teal,
              )),
          SizedBox(
            height: 20,
            width: 200,
            child: Divider(
              color: Colors.teal.shade700,
            ),
          ),
          Text(users.email),
          Text(users.detail),
          SizedBox(
            width: 350,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () async {
                logOut();
              },
              child: const Text('Đăng xuất'),
            ),
          ),
        ],
      );
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => SignInScreen())));
  }
}
