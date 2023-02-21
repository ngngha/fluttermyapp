import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/data/model/project_model.dart';
import 'package:job_manager/data/model/task_model.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class TaskService extends StatefulWidget {
  const TaskService({Key? key, this.taskModal}) : super(key: key);
  final Task? taskModal;
  
  static const String routeName = '/task_screen_service';
  @override
  State<TaskService> createState() => _TaskServiceState();
}

class _TaskServiceState extends State<TaskService> {
  Project? selected_project;
  // Project nameProject;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  TextEditingController? employeeController;
  TextEditingController? taskTitleController;
  TextEditingController? taskDetailController;
  @override
  void initState() {
    if (widget.taskModal != null) {
      employeeController =
          TextEditingController(text: widget.taskModal?.employee);
      taskTitleController =
          TextEditingController(text: widget.taskModal?.title);
      taskDetailController =
          TextEditingController(text: widget.taskModal?.detail);
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
    return AppBarContainer(
      title: widget.taskModal == null
          ? Row(
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
                      'Create Task',
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.delete,
                  color: Colors.transparent,
                ),
              ],
            )
          : Row(
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
                      'Edit Task',
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () async {
                    if (await confirm(
                      context,
                      title: const Text('Please Confirm'),
                      content: Text(
                          "Are you sure you want to delete '${taskTitleController!.text}' ?"),
                      textOK: const Text('Confirm'),
                      textCancel: const Text('Cancel'),
                    )) {
                      setState(() {
                        isLoading = true;
                      });
                      deleteTask(name: widget.taskModal!.id.toString());
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
      child: Scaffold(
          body: isLoading
              ? CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: [
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
                                      List<DropdownMenuItem<Project>>
                                          currentItems = [];
                                      snapshot.data?.forEach((value) {
                                        currentItems.add(
                                          DropdownMenuItem(
                                            value: value,
                                            child: Text(value.name),
                                          ),
                                        );
                                     
                                      });
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return DropdownButton<Project>(
                                          value: selected_project,
                                          items: currentItems,
                                          onChanged: (value) {
                                            setState(() {
                                              selected_project = value;
                                            });
                                          },
                                          // validator: (value)=> value == null ? 'field required': null,
                                        );
                                        
                                      });
                                    
                                    }
                                  }),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    width: 350,
                                    child: TextFormField(
                                      controller: taskTitleController,
                                      validator: (val) => val!.isEmpty
                                          ? 'Không được bỏ trống'
                                          : null,
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
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 10),
                                //   child: SizedBox(
                                //     width: 350,
                                //     child: TextField(
                                //       decoration: InputDecoration(
                                //           border: OutlineInputBorder(),
                                //           hintText: '${auth.currentUser!.displayName}',
                                //           prefixIcon: Icon(
                                //             Icons.person,
                                //             color: Colors.teal,
                                //           )),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 60),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 350,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.teal,
                                              textStyle: const TextStyle(
                                                  fontSize: 20)),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              widget.taskModal == null
                                                  ? createTask(
                                                      name: taskTitleController!
                                                          .text)
                                                  : updateTask(
                                                      name: taskTitleController!
                                                          .text);
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
                )),
    );
    
  }

  Stream<List<Project>> readProject() => FirebaseFirestore.instance
      .collection('projects')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList());
  void createTask({required name}) async {
    final docTask = FirebaseFirestore.instance.collection('tasks').doc();

    final task = Task(
      id: docTask.id,
      projectId: selected_project!.id,
      projectName: selected_project!.name,
      title: taskTitleController!.text,
      employee: auth.currentUser!.displayName ?? '',
      employeeId: auth.currentUser!.uid,
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
    final docTask = FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskModal!.id.toString());
    final task = Task(
      id: widget.taskModal!.id.toString(),
      projectId: selected_project!.id,
      projectName: selected_project!.name,
      title: taskTitleController!.text,
      employee: auth.currentUser!.displayName ?? '',
      employeeId: auth.currentUser!.uid,
      detail: taskDetailController!.text,
    );
    final json = task.toJson();
    await docTask.update(json);
    // Duration(milliseconds: 1000000);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sửa thành công dự án')),
    );
  }

  void deleteTask({required String name}) async {
    final docTask = FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskModal!.id.toString());
    // Duration(seconds: 1000000);
    await docTask.delete();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa')),
    );
  }
}
