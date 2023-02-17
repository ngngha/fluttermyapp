import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/data/model/project_model.dart';
import 'package:job_manager/data/model/task_model.dart';
import 'package:job_manager/data/model/user_model.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key, this.projectModal})
      : super(key: key);
  static const String routeName = '/add_project_screen';
  final Project? projectModal;

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final _formKey = GlobalKey<FormState>();
  UserModel? selected_user;
  TextEditingController? userController;
  TextEditingController? projectNameController;
  TextEditingController? projectDetailController;
  @override
  void initState() {
    if (widget.projectModal != null) {
      userController = TextEditingController(text: widget.projectModal?.user);
      projectNameController =
          TextEditingController(text: widget.projectModal?.name);
      projectDetailController =
          TextEditingController(text: widget.projectModal?.detail);
    } else {
      userController = TextEditingController();
      projectNameController = TextEditingController();
      projectDetailController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.projectModal);
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
          widget.projectModal == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Create Project',
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Edit Project',
                    ),
                  ],
                ),
          Spacer(),
          Icon(
            Icons.delete,
            color: Colors.transparent,
          ),
          // IconButton(
          //   onPressed: () async {
          //     if (_formKey.currentState!.validate()) {
          //       deleteProject(name: projectNameController!.text);
          //     }
          //   },
          //   icon: Icon(Icons.delete),
          //   color: Colors.transparent,
          // ),
        ],
      ),
      child: Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: projectNameController,
                        validator: (val) =>
                            val!.isEmpty ? 'Không được bỏ trống' : null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Tên dự án',
                            prefixIcon: Icon(
                              Icons.task,
                              color: Colors.teal,
                            )),
                      ),
                    ),
                  ),
                  StreamBuilder<List<UserModel>>(
                    stream: readUser(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        List<DropdownMenuItem<UserModel>> currentItems = [];
                        snapshot.data?.forEach((element) {
                          currentItems.add(
                            DropdownMenuItem(
                              value: element,
                              child: Text(element.username),
                            ),
                          );
                        });
                        return StatefulBuilder(builder: (context, setState) {
                          return DropdownButton<UserModel>(
                            value: selected_user,
                            items: currentItems,
                            onChanged: (value) {
                              setState(() {
                                selected_user = value;
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
                        minLines: 4,
                        maxLines: 4,
                        controller: projectDetailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Mô tả sơ bộ dự án'),
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
                              // final name = projectNameController.text;
                              if (_formKey.currentState!.validate()) {
                                widget.projectModal == null
                                    ? createProject(
                                        name: projectNameController!.text)
                                    : updateProject(
                                        name: projectNameController!.text);
                              }
                            },
                            child: widget.projectModal == null
                                ? Text('Thêm mới')
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

  Stream<List<UserModel>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

  void createProject({required name}) async {
    final docProject = FirebaseFirestore.instance.collection('projects').doc();
    final project = Project(
      id: docProject.id,
      name: projectNameController!.text,
      user: selected_user!.username,
      detail: projectDetailController!.text,
    );
    final json = project.toJson();
    await docProject.set(json);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Thêm thành công dự án')),
    // );
    Navigator.of(context).pop();
  }

  void updateProject({required String name}) async {
    final docProject = FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectModal!.id.toString());
    final project = Project(
      id: widget.projectModal!.id.toString(),
      name: projectNameController!.text,
      user: selected_user!.username,
      detail: projectDetailController!.text,
    );
    final json = project.toJson();
    await docProject.update(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sửa thành công dự án')),
    );
  }

//   void deleteProject({required String name}) async {
//     final docProject = FirebaseFirestore.instance
//         .collection('project')
//         .doc(widget.projectModal!.id.toString());
//     // final docTask = FirebaseFirestore.instance
//     //     .collection('task')
//     //     .doc(widget.taskModal!.projectId.toString());
// // if(taskModel){};
//     await docProject.delete();
//     // await docTask.delete();
//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Đã xóa')),
//     );
//   }
}
