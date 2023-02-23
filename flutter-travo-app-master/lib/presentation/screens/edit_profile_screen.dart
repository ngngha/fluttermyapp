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
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  User? currentUser = FirebaseAuth.instance.currentUser;
  late TextEditingController usernameController;
  late TextEditingController userGenderController;
  late TextEditingController phoneNumberController;
  late TextEditingController userDetailController;
  @override
  void initState() {
    if (widget.userModel != null) {
      usernameController =
          TextEditingController(text: widget.userModel!.username);
      userGenderController =
          TextEditingController(text: widget.userModel!.gender);
      phoneNumberController =
          TextEditingController(text: widget.userModel!.phoneNumber);
      userDetailController =
          TextEditingController(text: widget.userModel!.detail);
    } else {
      usernameController = TextEditingController();
      userGenderController = TextEditingController();
      phoneNumberController = TextEditingController();
      userDetailController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(currentUserId);
    // User? currentUser = auth.currentUser;
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
                  streamBuilderEditUserName(
                      currentUser, "username", "Username"),
                  streamBuilderEditPhone(
                      currentUser, "phoneNumber", "Phone number"),
                  streamBuilderEditGender(currentUser, "gender", "Gender"),
                  streamBuilderEditInfo(currentUser, "detail", "Detail"),
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
                              if (_formKey.currentState!.validate()) {
                                updateUserProfile(id: currentUserId);
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
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);
    final user = UserModel(
      id: currentUserId,
      username: usernameController.text,
      email: currentUserEmail ?? "",
      phoneNumber: phoneNumberController.text,
      gender: userGenderController.text,
      detail: userDetailController.text,
    );
    final json = user.toJson();
    await docUser.update(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved user info')),
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>
      streamBuilderEditUserName(
          User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getUserInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (usernameController.text.isNotEmpty) {
          currentUser!.updateDisplayName(usernameController.text);
        }
        return TextFormField(
          controller: usernameController,
          validator: (val) => val!.isEmpty
              ? 'Field can not be empty'
              : null,
          decoration: InputDecoration(
              labelText: labelName,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.person,
              )),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditPhone(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getUserInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return TextFormField(
          controller: phoneNumberController,
          validator: (val) => val!.isEmpty ||
                  !RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                      .hasMatch(val)
              ? 'Must be a valid phone number'
              : null,
          decoration: InputDecoration(
              labelText: labelName,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.phone,
              )),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditGender(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getUserInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return TextField(
          controller: userGenderController,
          decoration: InputDecoration(
              labelText: labelName,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                FontAwesomeIcons.venusMars,
              )),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditInfo(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getUserInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return TextField(
          controller: userDetailController,
          decoration: InputDecoration(
              labelText: labelName,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.description,
              )),
        );
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() {
    var collection = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .snapshots();
    return collection;
  }

  void logOut() async {
    LocalStorageHelper.setValue('ignoreIntro', false);
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => SignInScreen())));
  }
}
