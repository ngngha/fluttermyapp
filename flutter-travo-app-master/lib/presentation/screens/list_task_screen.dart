import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/dimension_constants.dart';
import 'package:travo_app_source/data/model/task_model.dart';
import 'package:travo_app_source/presentation/screens/task_screen_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travo_app_source/presentation/widgets/app_bar_container.dart';

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
    // await _loadResources(true);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBarContainer(
    titleString: 'My Tasks',
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: kItemPadding),
      child: Container(
        child: Text('My Tasks'),
      ),
    ),
    child:
     Scaffold(
      // appBar: AppBar(
      //   title: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: kItemPadding),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Column(
      //           // crossAxisAlignment: CrossAxisAlignment.,
      //           children: [
      //             Text(
      //               'My Tasks',
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
          
      //   ),
      //   flexibleSpace: Stack(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(
      //                 gradient: const LinearGradient(
      //                   colors: [
      //                     Colors.teal,
      //                     Color.fromARGB(255, 57, 128, 111)
      //                   ],
      //                 ),
      //                 borderRadius: BorderRadius.only(
      //                   bottomLeft: Radius.circular(25),
      //                   bottomRight: Radius.circular(25),
      //                 ),
                      
      //               ),
      //             ),
      //           ],
      //         ),
      //         // centerTitle: true,
      //         // automaticallyImplyLeading: false,
      //         elevation: 0,
      //         toolbarHeight: 76,
      //         backgroundColor: Colors.white,
      //   // title: Text(''),
      //   // toolbarHeight: 100,
      // ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
          // padding: EdgeInsets.symmetric(
          //     vertical: kMediumPadding, horizontal: kDefaultPadding),
          child: FutureBuilder<List<Task>?>(
            future: readTaskInfo(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tasks = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(TaskService.routeName,
                              arguments: tasks[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.circular(kItemPadding)),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.thumbtack,
                                color: Colors.teal,
                              ),
                              SizedBox(
                                width: kDefaultPadding,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tasks[index].title,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Dang lam',
                                    style: theme.textTheme.titleMedium,
                                  )
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
