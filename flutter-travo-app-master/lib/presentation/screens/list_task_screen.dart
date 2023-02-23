import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/data/model/task_model.dart';
import 'package:job_manager/presentation/screens/task_screen_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class ListTask extends StatefulWidget {
  const ListTask({Key? key, this.taskModal}) : super(key: key);
  static const String routeName = '/list_task_screen';
  final Task? taskModal;

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future refresh() async {
    //  initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return AppBarContainer(
      titleString: 'My Tasks',
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Text('My Tasks'),
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: StreamBuilder<List<Task>>(
            stream: readTaskInfo(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final task = snapshot.data!;
                return ListView(
                  padding: EdgeInsets.all(0),
                  // padding: EdgeInsets.symmetric(
                  //     vertical: kMediumPadding, horizontal: kDefaultPadding),
                  children: task.map(buildTask).toList(),
                );
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
            Navigator.of(context).pushNamed(TaskService.routeName);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Stream<List<Task>> readTaskInfo(String employeeId) =>
      FirebaseFirestore.instance.collection('tasks').where('employeeId', isEqualTo: employeeId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((employeeId)  => Task.fromJson(employeeId.data()))
              .toList());
              
  Widget buildTask(Task task) => Container(
        padding: EdgeInsets.only(bottom: 20),
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
            //     SizedBox(
            //   width: 350,
            //   height: 50,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.teal,
            //         textStyle: const TextStyle(fontSize: 20)),
            //     onPressed: () async {
            //       print('3463${auth.currentUser!.email}');
            //       logOut();
            //     },
            //     child: const Text('Đăng xuất'),
            //   ),
            // ),
              ],
            ),
            
          ),
        ),
      );
  //     void logOut() async {
  //   // LocalStorageHelper.setValue('ignoreIntro', false);
  //   await auth.signOut();

  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: ((context) => SignInScreen())));
  // }
}
