import 'package:flutter/material.dart';
import 'package:travo_app_source/representation/screen/addproject.dart';

class ListProject extends StatefulWidget {
  const ListProject({Key? key}) : super(key: key);
  static String routeName = '/listproject_screen';

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
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(AddProject.routeName);
          }, icon: Icon(Icons.add),)
        ],
      ),
    );
  }
}