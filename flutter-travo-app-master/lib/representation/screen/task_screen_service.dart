import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/data/model/task_model.dart';

class TaskService extends StatefulWidget {
  const TaskService({Key? key, this.taskModal}) : super(key: key);
  final Task? taskModal;
  static const String routeName = '/task_screen_service';
  @override
  State<TaskService> createState() => _TaskServiceState();
}

class _TaskServiceState extends State<TaskService> {
  Project? selected_project;
  final _formKey = GlobalKey<FormState>();
  // DateTime? picked;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  TextEditingController? employeeController;
  TextEditingController? taskTitleController;
  TextEditingController? taskDetailController;
  // TextEditingController? dateCreateController;
  @override
  void initState() {
    if (widget.taskModal != null) {
      employeeController =
          TextEditingController(text: widget.taskModal?.employee);
      taskTitleController =
          TextEditingController(text: widget.taskModal?.title);
      taskDetailController =
          TextEditingController(text: widget.taskModal?.detail);
      // dateCreateController = TextEditingController(text: widget.taskModal?.name);
    } else {
      employeeController = TextEditingController();
      taskTitleController = TextEditingController();
      taskDetailController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.taskModal);
    return Scaffold(
        appBar: widget.taskModal == null
            ? AppBar(
                title: Text('Tạo nhiệm vụ'),
              )
            : AppBar(
                title: Text('Chỉnh sửa nhiệm vụ'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        deleteTask(name: taskTitleController!.text);
                      }
                    },
                    icon: Icon(Icons.delete),
                  )
                ],
              ),
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
                    StreamBuilder<List<Project>>(
                      stream: readProject(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          List<DropdownMenuItem<Project>> currentItems = [];
                          snapshot.data?.forEach((element) {
                            // DocumentSnapshot snap = snapshot.data.map((e) => null);
                            // element = userController!.text as Task;
                            currentItems.add(
                              DropdownMenuItem(
                                value: element,
                                child: Text(element.name),
                              ),
                            );
                          });
                          // Project? currentItem;
                          return StatefulBuilder(builder: (context, setState) {
                            return DropdownButton<Project>(
                              value: selected_project,
                              items: currentItems,
                              onChanged: (value) {
                                setState(() {
                                  selected_project = value;
                                });
                              },
                            );
                          });
                        }
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: taskTitleController,
                          validator: (val) =>
                              val!.isEmpty ? 'Không được bỏ trống' : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nhiệm vụ',
                              prefixIcon: Icon(
                                Icons.task,
                                color: Colors.teal,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: 350,
                        child: TextField(
                          // validator: (val) =>
                          //     val!.isEmpty ? 'Không được bỏ trống' : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '${auth.currentUser!.displayName}',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.teal,
                              )),
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
                          controller: taskDetailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Công việc cụ thể'),
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
                                // final name = taskTitleController.text;
                                if (_formKey.currentState!.validate()) {
                                  widget.taskModal == null
                                      ? createTask(
                                          name: taskTitleController!.text)
                                      : updateTask(
                                          name: taskTitleController!.text);
                                }
                              },
                              child: widget.taskModal == null
                                  ? Text('Tạo mới')
                                  : Text('Chỉnh sửa'),
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
        ));
  }

  Stream<List<Project>> readProject() => FirebaseFirestore.instance
      .collection('project')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList());
  void createTask({required name}) async {
    final docTask = FirebaseFirestore.instance.collection('task').doc();

    final task = Task(
      id: docTask.id,
      projectId: selected_project!.id,
      // projectName: selected_project!.name,
      title: taskTitleController!.text,
      employee: auth.currentUser?.displayName ?? '',
      employeeId: auth.currentUser?.uid ?? '',
      detail: taskDetailController!.text,
    );
    final json = task.toJson();
    await docTask.set(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thêm thành công nhiệm vụ')),
    );
  }

  void updateTask({required String name}) async {
    final docProject = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.taskModal!.id.toString());
    final task = Task(
      id: widget.taskModal!.id.toString(),
      projectId: selected_project!.id,
      // projectName: selected_project!.name,
      title: taskTitleController!.text,
      employee: auth.currentUser?.displayName ?? '',
      employeeId: auth.currentUser?.uid ?? '',
      detail: taskDetailController!.text,
    );
    final json = task.toJson();
    await docProject.update(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sửa thành công dự án')),
    );
  }

  void deleteTask({required String name}) async {
    final docProject = FirebaseFirestore.instance
        .collection('task')
        .doc(widget.taskModal!.id.toString());
    await docProject.delete();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa')),
    );
  }
}