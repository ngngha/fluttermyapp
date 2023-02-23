import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/core/helpers/asset_helper.dart';
import 'package:job_manager/core/helpers/image_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_manager/data/model/user_model.dart';
import 'package:job_manager/presentation/screens/edit_profile_screen.dart';
import 'package:job_manager/presentation/screens/signin_screen.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.userModel}) : super(key: key);
  static const String routeName = '/profile_screen';
  final UserModel? userModel;
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
    return AppBarContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.edit,
            color: Colors.transparent,
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Profile',
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProfileScreen.routeName);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<UserModel?>(
            future: readUserInfo(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildProject(snapshot.data as UserModel);
              } else if (snapshot.hasError) {
                return Text(snapshot.toString());
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(EditProfileScreen.routeName);
        //   },
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.edit),
        // ),
      ),
    );
  }

  Future<UserModel?> readUserInfo(String id) async {
    setState(() {});
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();

    final List<UserModel> list =
        result.docs.map((e) => UserModel.fromJson(e.data())).toList();

    return list.isEmpty ? null : list.first;
  }

  Widget buildProject(UserModel user) => Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stack(
            //   children:
            // ),
            // Padding(padding: EdgeInsets.all(5)),
            // Text(user.level, style: TextStyle(fontSize: 16)),
            Padding(padding: EdgeInsets.all(5)),
            Text(user.email,
                style: TextStyle(color: Colors.teal, fontSize: 18)),

            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.teal.shade700,
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 30,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username'),
                        Text(
                          user.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  width: 200,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      size: 30,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email'),
                        Text(
                          user.email,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  width: 200,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 30,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone'),
                        Text(
                          user.phoneNumber,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  width: 200,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.venusMars,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gender'),
                        Text(
                          user.gender,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  width: 200,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description,
                      size: 30,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description'),
                        Text(
                          user.detail,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(30)),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () async {
                  // print('3463${auth.currentUser!.email}');
                  logOut();
                },
                child: const Text('Sign out'),
              ),
            ),
          ],
        ),
      );

  void logOut() async {
    // LocalStorageHelper.setValue('ignoreIntro', false);
    await auth.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => SignInScreen())));
  }
}
