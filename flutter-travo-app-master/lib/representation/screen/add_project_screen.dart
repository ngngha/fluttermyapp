import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/data/model/user_model.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key, this.projectModal}) : super(key: key);
  static const String routeName = '/add_project_screen';
  final Project? projectModal;

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final _formKey = GlobalKey<FormState>();
  Users? selected_user;
  // DateTime? picked;
  TextEditingController? userController;
  TextEditingController? projectNameController;
  TextEditingController? projectDetailController;
  // TextEditingController? dateCreateController;
  @override
  void initState() {
    if (widget.projectModal != null) {
      userController = TextEditingController(text: widget.projectModal?.user);
      projectNameController =
          TextEditingController(text: widget.projectModal?.name);
      projectDetailController =
          TextEditingController(text: widget.projectModal?.detail);
      // dateCreateController = TextEditingController(text: widget.projectModal?.name);
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
    return Scaffold(
        appBar: widget.projectModal == null
            ? AppBar(
                title: Text('Thêm mới dự án'),
              )
            : AppBar(
                title: Text('Chỉnh sửa dự án'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        deleteProject(name: projectNameController!.text);
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
                    StreamBuilder<List<Users>>(
                      stream: readUser(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          List<DropdownMenuItem<Users>> currentItems = [];
                          snapshot.data?.forEach((element) {
                            // element = userController!.text as Users;
                            currentItems.add(
                              DropdownMenuItem(
                                value: element,
                                child: Text(element.username),
                              ),
                            );
                          });
                          Users? currentItem;
                          return StatefulBuilder(builder: (context, setState) {
                            return DropdownButton<Users>(
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: SizedBox(
                    //     width: 350,
                    //     child: TextFormField(
                    //       controller: userController,
                    //       validator: (val) =>
                    //           val!.isEmpty ? 'Không được bỏ trống' : null,
                    //       decoration: InputDecoration(
                    //           border: OutlineInputBorder(),
                    //           hintText: 'Người phụ trách',
                    //           prefixIcon: Icon(
                    //             Icons.person,
                    //             color: Colors.teal,
                    //           )),
                    //     ),
                    //   ),
                    // ),
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
        ));
  }

  Stream<List<Users>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

  void createProject({required name}) async {
    final docProject = FirebaseFirestore.instance.collection('project').doc();
    final project = Project(
      id: docProject.id,
      name: projectNameController!.text,
      user: selected_user!.username,
      detail: projectDetailController!.text,
    );
    final json = project.toJson();
    await docProject.set(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thêm thành công dự án')),
    );
  }

  void updateProject({required String name}) async {
    final docProject = FirebaseFirestore.instance
        .collection('project')
        .doc(widget.projectModal!.id.toString());
    final project = Project(
      id: widget.projectModal!.id.toString(),
      name: projectNameController!.text,
      user: userController!.text,
      detail: projectDetailController!.text,
    );
    final json = project.toJson();
    await docProject.update(json);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sửa thành công dự án')),
    );
  }

  void deleteProject({required String name}) async {
    final docProject = FirebaseFirestore.instance
        .collection('project')
        .doc(widget.projectModal!.id.toString());
    await docProject.delete();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa')),
    );
  }
}
