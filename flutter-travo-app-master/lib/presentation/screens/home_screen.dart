import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travo_app_source/core/constants/textstyle_ext.dart';
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
  String checkIn = "--:--";
  String checkOut = "--:--";
  void getId()async{
    
  }
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
  void initState() {
    super.initState();
    _getAttend();
  }

  void _getAttend() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: auth.currentUser!.uid)
          .get();
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection('users')
          .doc(snap.docs[0].id)
          .collection('Attend')
          .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
          .get();
      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "--:--";
        checkOut = "--:--";
      });
    }
    print(checkIn);
    print(checkOut);
  }

  @override
  Widget build(BuildContext context) {
    Future refresh() async {
      // await _loadResources(true);
    }
    return AppBarContainer(
      titleString: 'home',
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Xin chào, ${auth.currentUser!.displayName}!',
                    style:
                        TextStyles.defaultStyle.fontHeader.whiteTextColor.bold),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        dateFormatter,
                        style:
                            TextStyles.defaultStyle.fontCaption.whiteTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                DateFormat('hh:mm:ss a').format(DateTime.now()),
                                style: TextStyles
                                    .defaultStyle.fontCaption.whiteTextColor,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ],
        ),
      ),
      implementLeading: false,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('In at ' + checkIn, style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  SizedBox(
                    width: kItemPadding,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('Out at ' + checkOut, style: Theme.of(context).textTheme.labelLarge,),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: checkOut == "--:--"
                        ? ElevatedButton(
                            onPressed: () async {
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .where('id', isEqualTo: auth.currentUser!.uid)
                                  .get();
                              DocumentSnapshot snap2 = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .doc(snap.docs[0].id)
                                  .collection('Attend')
                                  .doc(DateFormat('MMMM yyyy')
                                      .format(DateTime.now()))
                                  .get();

                              try {
                                String checkIn = snap2['checkIn'];
                                setState(() {
                                  checkOut = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snap.docs[0].id)
                                    .collection('Attend')
                                    .doc(DateFormat('MMMM yyyy')
                                        .format(DateTime.now()))
                                    .update({
                                  'checkIn': checkIn,
                                  'checkOut': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                });
                              } catch (e) {
                                setState(() {
                                  checkIn = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snap.docs[0].id)
                                    .collection('Attend')
                                    .doc(DateFormat('MMMM yyyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'checkIn':
                                      DateFormat('hh:mm').format(DateTime.now())
                                });
                              }
                              // print(DateFormat('dd MMMM yyyy').format(DateTime.now()));
                            },
                            child: checkIn == "--:--"
                                ? Text("Check in")
                                : Text("Check out"),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text('Already Check in/out', style: Theme.of(context).textTheme.labelLarge,)],
                          ),
                  ),
                ],
              ),
            ],
          ),
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
            child: RefreshIndicator(
              onRefresh: refresh,
              child: FutureBuilder<List<Task>?>(
                future: readTaskInfo(auth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tasks = snapshot.data!;
                    return ListView.separated(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                TaskService.routeName,
                                arguments: tasks[index]);
                          },
                          child: Container(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Text(
                                      'Dang lam',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
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
