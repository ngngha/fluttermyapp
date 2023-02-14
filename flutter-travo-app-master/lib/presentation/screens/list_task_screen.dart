import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/dimension_constants.dart';
import 'package:travo_app_source/data/model/task_model.dart';
import 'package:travo_app_source/presentation/screens/task_screen_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nhiệm vụ'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(TaskService.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: kMediumPadding, horizontal: kDefaultPadding),
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
                        Navigator.of(context).pushNamed(TaskService.routeName,
                            arguments: tasks[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(kItemPadding)),
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
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'Dang lam',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
