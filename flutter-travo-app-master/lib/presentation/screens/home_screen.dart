import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travo_app_source/core/constants/textstyle_ext.dart';
import 'package:travo_app_source/core/helpers/asset_helper.dart';
import 'package:travo_app_source/core/helpers/image_helper.dart';
import 'package:travo_app_source/data/model/task_model.dart';
import 'package:travo_app_source/presentation/screens/list_project_screen.dart';
import 'package:travo_app_source/presentation/screens/list_task_screen.dart';
import 'package:travo_app_source/presentation/screens/profile_screen.dart';
import 'package:travo_app_source/presentation/screens/task_screen_service.dart';
import 'package:travo_app_source/presentation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/dimension_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final today = DateTime.now();
  String dateFormatter = DateFormat.yMMMMd('en_US').format(DateTime.now());
  Widget _buildItemCategory(
      Widget icon, Color color, Function() onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: kMediumPadding,
            ),
            child: icon,
            decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kItemPadding)),
          ),
          SizedBox(
            height: kItemPadding,
          ),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      titleString: 'home',
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   height: 40,
            //   width: 40,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(
            //       12,
            //     ),
            //     color: Colors.white,
            //   ),
            //   padding: EdgeInsets.all(kItemPadding),
            //   child: ImageHelper.loadFromAsset(
            //     AssetHelper.person,
            //   ),
            // ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Xin chào, ${auth.currentUser!.displayName}!',
                    style:
                        TextStyles.defaultStyle.fontHeader.whiteTextColor.bold),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    dateFormatter,
                    style: TextStyles.defaultStyle.fontCaption.whiteTextColor,
                  ),
                )
              ],
            ),
            Spacer(),
            Icon(
              Icons.notifications,
              // size: kDefaultIconSize,
              color: Colors.white,
            ),
            // SizedBox(
            //   width: kMinPadding,
            // ),
          ],
        ),
      ),
      implementLeading: false,
      child: Column(
        children: [
          SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: _buildItemCategory(
                    SizedBox(
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                      child:
                          Icon(FontAwesomeIcons.listCheck, color: Colors.teal),
                    ),
                    Colors.teal, () {
                  Navigator.of(context).pushNamed(ListProject.routeName);
                }, 'Dự án'),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: _buildItemCategory(
                    SizedBox(
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                      child:
                          Icon(FontAwesomeIcons.thumbtack, color: Colors.teal),
                    ),
                    Colors.teal, () {
                  Navigator.of(context).pushNamed(ListTask.routeName);
                }, 'Task'),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: _buildItemCategory(
                    SizedBox(
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                      child: Icon(FontAwesomeIcons.user, color: Colors.teal),
                    ),
                    Colors.teal, () {
                  Navigator.of(context).pushNamed(ProfileScreen.routeName);
                }, 'Nhân viên'),
              ),
            ],
          ),
          SizedBox(
            width: kDefaultIconSize,
            height: kDefaultIconSize,
          ),
          Expanded(
            child: FutureBuilder<List<Task>?>(
              future: readTaskInfo(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data!;
                  return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(kItemPadding)),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.thumbtack,
                                color: Colors.teal,
                              ),
                              SizedBox(
                                width: kItemPadding,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tasks[index].title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Dang lam',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                ],
                              ),
                              Spacer(),
                              // InkWell(onTap: Icon(Icons.more_horiz)),
                            ],
                          ),

                          // ListTile(
                          //   leading: Icon(
                          //     FontAwesomeIcons.thumbtack,
                          //     color: Colors.teal,
                          //   ),
                          //   title: Text(
                          //     tasks[index].title,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          //   subtitle: Text(''),
                          //   onTap: () => {
                          //     // print('click'),
                          //     Navigator.of(context).pushNamed(
                          //         TaskService.routeName,
                          //         arguments: tasks[index]),
                          //   },
                          // ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text(snapshot.toString());
                } else {
                  return Center(
                    child: Text('Bạn chưa có nhiệm vụ nào'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Task>?> readTaskInfo(String employeeId) async {
    final result = await FirebaseFirestore.instance
        .collection('task')
        .where('employeeId', isEqualTo: employeeId)
        .get();

    final List<Task> list =
        result.docs.map((e) => Task.fromJson(e.data())).toList();

    return list.isEmpty ? null : list;
  }
}
