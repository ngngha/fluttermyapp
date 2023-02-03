import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/task_model.dart';
import 'package:travo_app_source/representation/screen/task_screen_service.dart';

class ListTask extends StatefulWidget {
  const ListTask({Key? key, this.taskModal}) : super(key: key);
  static const String routeName = '/list_task_screen';
  final Task? taskModal;

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  final FirebaseAuth auth = FirebaseAuth.instance;
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
      body: FutureBuilder<List<Task>?>(
        future: readTaskInfo(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(tasks[index].title),
                    title: Text(tasks[index].employee),
                    subtitle: Text(tasks[index].projectId),
                    onTap: () => {
                      // print('click'),
                      Navigator.of(context)
                          .pushNamed(TaskService.routeName, arguments: tasks[index]),
                    },
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
    );
  }

  // Stream<List<Task>> readTask() => FirebaseFirestore.instance
  //     // .collection('users')
  //     // .doc(auth.currentUser!.uid)
  //     .collection('task')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
  // Widget buildTask(Task task) => ListTile(
  //       leading: Text(task.title),
  //       title: Text(task.employee)
  //       subtitle: Text(task.detail),
  //       onTap: () => {
  //         Navigator.of(context)
  //             .pushNamed(TaskService.routeName, arguments: task),
  //       },
  //     );
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
