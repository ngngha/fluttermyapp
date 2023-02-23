import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/data/model/user_model.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class ListEmployee extends StatefulWidget {
  const ListEmployee({Key? key}) : super(key: key);
  static const String routeName = '/list_employee';

  @override
  State<ListEmployee> createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
  Future refresh() async {
    // await _loadResources(true);
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
                'List Employee',
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.notifications,
            color: Colors.transparent,
          ),
        ],
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: StreamBuilder<List<UserModel>>(
            stream: readProject(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final project = snapshot.data!;
                return ListView(
                  padding: EdgeInsets.all(0),
                  // padding: EdgeInsets.symmetric(
                  //     vertical: kMediumPadding, horizontal: kDefaultPadding),
                  children: project.map(buildProject).toList(),
                );
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
        //     Navigator.of(context).pushNamed(AddProject.routeName);
        //   },
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }

  Stream<List<UserModel>> readProject() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  Widget buildProject(UserModel user) => Container(
        padding: EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context)
            //     .pushNamed(AddProject.routeName, arguments: project);
          },
          child: Container(
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                // color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kItemPadding)),
            child: Row(
              children: [
                // Icon(FontAwesomeIcons.listCheck, color: Colors.teal),
                SizedBox(
                  width: kDefaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Spacer(),
                
              ],
            ),
          ),
        ),
      );
}