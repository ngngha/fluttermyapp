import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/representation/screen/add_project_screen.dart';

class ListProject extends StatefulWidget {
  const ListProject({Key? key}) : super(key: key);
  static const String routeName = '/listproject_screen';

  @override
  State<ListProject> createState() => _ListProjectState();
}

class _ListProjectState extends State<ListProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách dự án'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProject.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<List<Project>>(
        stream: readProject(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final projects = snapshot.data!;
            return ListView(
              children: projects.map(buildProject).toList(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Stream<List<Project>> readProject() => FirebaseFirestore.instance
      .collection('project')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList());
  Widget buildProject(Project project) => ListTile(
        leading: Text(project.name),
        title: Text(project.user),
        subtitle: Text(project.detail),
        onTap: () => {
          
          Navigator.of(context)
              .pushNamed(AddProject.routeName, arguments: project),
        },
      );
}