import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_manager/core/constants/textstyle_ext.dart';
import 'package:job_manager/data/model/task_model.dart';
import 'package:job_manager/presentation/screens/attendance_screen.dart';
import 'package:job_manager/presentation/screens/list_task_screen.dart';
import 'package:job_manager/presentation/screens/profile_screen.dart';
import 'package:job_manager/presentation/screens/task_screen_service.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/dimension_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String checkIn = "--:--";
  final FirebaseAuth auth = FirebaseAuth.instance;
  String checkOut = "--:--";
  void getId() async {}
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
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
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
    // print(checkIn);
    // print(checkOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                Text(
                  'Hello, ${auth.currentUser!.displayName}!',
                ),
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
                    child: Text(
                      'In at ' + checkIn,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(
                    width: kItemPadding,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Out at ' + checkOut,
                      style: theme.textTheme.labelLarge,
                    ),
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
                                  .doc(DateFormat('dd MMMM yyyy')
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
                                    .doc(DateFormat('dd MMMM yyyy')
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
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'checkIn': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  'checkOut': "--:--"
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
                            children: [
                              Text(
                                'Already Check in/out',
                                style: theme.textTheme.labelLarge,
                              )
                            ],
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
                      child: Icon(
                        FontAwesomeIcons.solidCalendarDays,
                        color: Colors.teal,
                      ),
                    ),
                    Colors.teal, () {
                  Navigator.of(context).pushNamed(CalendarScreen.routeName);
                }, 'Attendance'),
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
                }, 'Employee'),
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
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: StreamBuilder<List<Task>>(
                  stream: readTaskInfo(auth.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final task = snapshot.data!;
                      return ListView(
                        padding: EdgeInsets.all(0),
                        // padding: EdgeInsets.symmetric(
                        //     vertical: kMediumPadding, horizontal: kDefaultPadding),
                        children: task.map(buildProject).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.toString());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Task>> readTaskInfo(String employeeId) =>
      FirebaseFirestore.instance.collection('tasks').where('employeeId', isEqualTo: employeeId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((employeeId) => Task.fromJson(employeeId.data()))
              .toList());
  Widget buildProject(Task task) => Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(TaskService.routeName, arguments: task);
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
                Icon(FontAwesomeIcons.thumbtack, color: Colors.teal),
                SizedBox(
                  width: kDefaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      task.employee + ' status',
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
