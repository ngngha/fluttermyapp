import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // List filterState = [];
  TextEditingController? usernameController;
  TextEditingController? userEmailController;
  TextEditingController? userGenderController;
  TextEditingController? phoneNumberController;
  TextEditingController? userDetailController;
  @override
  void initState() {
    if (widget.userModel != null) {
      usernameController =
          TextEditingController(text: widget.userModel!.username);
      userEmailController =
          TextEditingController(text: widget.userModel!.email);
      userGenderController =
          TextEditingController(text: widget.userModel!.gender);
      phoneNumberController =
          TextEditingController(text: widget.userModel!.phoneNumber);
      userDetailController =
          TextEditingController(text: widget.userModel!.detail);
    } else {
      usernameController = TextEditingController();
      userEmailController = TextEditingController();
      userGenderController = TextEditingController();
      phoneNumberController = TextEditingController();
      userDetailController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userModel);
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
          body: Form(
        key: _formKey,
        child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: SizedBox(
                  //     width: 350,
                  //     child: TextFormField(
                  //       controller: phoneNumberController,
                  //       validator: (val) =>
                  //           val!.isEmpty ? 'This field cannot be empty.' : null,
                  //       decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           hintText: 'sjhf',
                  //           prefixIcon: Icon(
                  //             Icons.person,
                  //           )),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: SizedBox(
                  //     width: 350,
                  //     child: TextFormField(
                  //       controller: phoneNumberController,
                  //       validator: (val) =>
                  //           val!.isEmpty ? 'This field cannot be empty.' : null,
                  //       decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           hintText: 'Email',
                  //           prefixIcon: Icon(
                  //             Icons.email,
                  //           )),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: phoneNumberController,
                        validator: (val) =>
                            val!.isEmpty ? 'This field cannot be empty.' : null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Phone number',
                            prefixIcon: Icon(
                              Icons.phone,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: userGenderController,
                        validator: (val) =>
                            val!.isEmpty ? 'This field cannot be empty.' : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Gender',
                          prefixIcon: Icon(
                            FontAwesomeIcons.venusMars,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        minLines: 4,
                        maxLines: 4,
                        controller: userDetailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description user'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          width: 350,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                textStyle: const TextStyle(fontSize: 20)),
                            onPressed: () async {
                              // final name = projectNameController.text;
                              if (_formKey.currentState!.validate()) {
                                updateUserProfile(id: auth.currentUser!.uid);
                              }
                            },
                            child: Text('Save edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      )),
    );
  }

  void updateUserProfile({required String id}) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel!.id.toString());
    final user = UserModel(
      id: widget.userModel!.id.toString(),
      // name: projectNameController!.text,
      // user: selected_user!.username,
      detail: userDetailController!.text,
    );
    final json = user.toJson();
    await docUser.update(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved user info')),
    );
  }
  // Stream<List<UserModel?>> readUserInfo1(String id) => FirebaseFirestore
  //     .instance
  //     .collection('users')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((id) => UserModel.fromJson(id.data())).toList());

  // Future<UserModel?> readUserInfo(String id) async {
  //   final result = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('id', isEqualTo: id)
  //       .get();

  //   final List<UserModel> list =
  //       result.docs.map((e) => UserModel.fromJson(e.data())).toList();

  //   return list.isEmpty ? null : list.first;
  // }

  // Widget buildProject(UserModel user) => Align(
  //       alignment: Alignment.center,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius: 50,
  //             child: ImageHelper.loadFromAsset(
  //               AssetHelper.person,
  //             ),
  //           ),
  //           Padding(padding: EdgeInsets.all(5)),
  //           Text(user.email,
  //               style: TextStyle(color: Colors.teal, fontSize: 18)),
  //           SizedBox(
  //             height: 20,
  //             width: 200,
  //             child: Divider(
  //               color: Colors.teal.shade700,
  //             ),
  //           ),
  //           Padding(padding: EdgeInsets.all(10)),
  //           Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 10),
  //                   child: SizedBox(
  //                     width: 350,
  //                     child: TextFormField(
  //                       minLines: 4,
  //                       maxLines: 4,
  //                       controller: us,
  //                       decoration: InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           hintText: 'Description Project'),
  //                     ),
  //                   ),
  //                 ),
  //           Padding(padding: EdgeInsets.all(30)),
  //           // SizedBox(
  //           //   width: 350,
  //           //   height: 50,
  //           //   child: ElevatedButton(
  //           //     style: ElevatedButton.styleFrom(
  //           //         backgroundColor: Colors.teal,
  //           //         textStyle: const TextStyle(fontSize: 20)),
  //           //     onPressed: () async {
  //           //       if (_formKey.currentState!.validate()) {
  //           //         updateUserInfo(id: user.id);
  //           //       }
  //           //     },
  //           //     child: const Text('Submit'),
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //     );

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
