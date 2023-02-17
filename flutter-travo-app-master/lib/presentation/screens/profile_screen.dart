import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/core/helpers/asset_helper.dart';
import 'package:job_manager/core/helpers/image_helper.dart';
import 'package:job_manager/core/helpers/local_storage_helper.dart';
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
  List filterState = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Text('Profile'),
      ),
      child: Scaffold(
        body:
            // StreamBuilder<List<UserModel?>>(
            SingleChildScrollView(
          child: FutureBuilder<UserModel?>(
            future:
                // stream:
                readUserInfo(auth.currentUser!.uid),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditProfileScreen.routeName);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Stream<List<UserModel?>> readUserInfo1(String id) => FirebaseFirestore
      .instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((id) => UserModel.fromJson(id.data())).toList());
  // Widget buildProject(Project project) => Container(
  //       padding: EdgeInsets.only(bottom: 20),
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.of(context)
  //               .pushNamed(AddProject.routeName, arguments: project);
  //         },
  //         child: Container(
  //           padding: EdgeInsets.all(kDefaultPadding),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Colors.black26,
  //                   blurRadius: 5,
  //                   offset: Offset(0, 2),
  //                 ),
  //               ],
  //               // color: Colors.grey.withOpacity(0.2),
  //               borderRadius: BorderRadius.circular(kItemPadding)),
  //           child: Row(
  //             children: [
  //               Icon(FontAwesomeIcons.listCheck, color: Colors.teal),
  //               SizedBox(
  //                 width: kDefaultPadding,
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     project.name,
  //                     style: Theme.of(context).textTheme.titleLarge,
  //                   ),
  //                   Text(
  //                     project.user + ' status',
  //                     style: Theme.of(context).textTheme.titleMedium,
  //                   ),
  //                 ],
  //               ),
  //               Spacer(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  Future<UserModel?> readUserInfo(String id) async {
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
            CircleAvatar(
              radius: 50,
              child: ImageHelper.loadFromAsset(
                AssetHelper.person,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(user.email,
                style: TextStyle(
                  color: Colors.teal, fontSize: 18
                )),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.teal.shade700,
              ),
            ),
            // Text(user.email),
            // Text(user.detail),
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
        ),
      );
  void logOut() async {
    LocalStorageHelper.setValue('ignoreIntro', false);
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => SignInScreen())));
  }
}
