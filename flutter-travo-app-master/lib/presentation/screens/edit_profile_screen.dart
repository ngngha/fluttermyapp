import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/core/helpers/asset_helper.dart';
import 'package:job_manager/core/helpers/image_helper.dart';
import 'package:job_manager/core/helpers/local_storage_helper.dart';
import 'package:job_manager/data/model/user_model.dart';
import 'package:job_manager/presentation/screens/signin_screen.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, this.userModel}) : super(key: key);
  static const String routeName = '/edit_profile_screen';
  final UserModel? userModel;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List filterState = [];
  // final _formKey = GlobalKey<FormState>();
  // UserModel? selected_user;
  TextEditingController? userNameController;
  TextEditingController? emailController;
  TextEditingController? userDetailController;
  @override
  void initState() {
    if (widget.userModel != null) {
      userNameController =
          TextEditingController(text: widget.userModel!.username);
      emailController = TextEditingController(text: widget.userModel!.email);
      userDetailController =
          TextEditingController(text: widget.userModel!.detail);
    } else {
      userNameController = TextEditingController();
      emailController = TextEditingController();
      userDetailController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Edit Profile',
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.delete,
            color: Colors.transparent,
          ),
        ],
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
      ),
    );
  }

  Stream<List<UserModel?>> readUserInfo1(String id) => FirebaseFirestore
      .instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((id) => UserModel.fromJson(id.data())).toList());

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
            Padding(padding: EdgeInsets.all(5)),
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
                      Icons.account_circle,
                      size: 30,
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level'),
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
            // SizedBox(
            //   width: 350,
            //   height: 50,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.teal,
            //         textStyle: const TextStyle(fontSize: 20)),
            //     onPressed: () async {
            //       if (_formKey.currentState!.validate()) {
            //         updateUserInfo(id: user.id);
            //       }
            //     },
            //     child: const Text('Submit'),
            //   ),
            // ),
          ],
        ),
      );

  void logOut() async {
    LocalStorageHelper.setValue('ignoreIntro', false);
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => SignInScreen())));
  }

  void updateUserInfo({required String id}) async {
    final docUserInfo = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel!.id.toString());
    // final docUserInfoauth = FirebaseAuth.instance
    //     .collection('users')
    //     .doc(widget.userModel!.id.toString());
    final user = UserModel(
      id: widget.userModel!.id.toString(),
      username: userNameController!.text,
      email: emailController!.text,
      detail: userDetailController!.text,
    );
    final json = user.toJson();
    await docUserInfo.update(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sửa thành công dự án')),
    );
  }
}
