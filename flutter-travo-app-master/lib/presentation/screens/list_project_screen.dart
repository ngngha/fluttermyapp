import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/dimension_constants.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/presentation/screens/add_project_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travo_app_source/presentation/widgets/app_bar_container.dart';

class ListProject extends StatefulWidget {
  const ListProject({Key? key}) : super(key: key);
  static const String routeName = '/listproject_screen';

  @override
  State<ListProject> createState() => _ListProjectState();
}

class _ListProjectState extends State<ListProject> {
  Future refresh() async {
    // await _loadResources(true);
  }
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      titleString: 'listProject',
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Container(
          child: Text('List Project'),
        ),
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: StreamBuilder<List<Project>>(
            stream: readProject(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final projects = snapshot.data!;
                return ListView(
                  padding: EdgeInsets.all(0),
                  // padding: EdgeInsets.symmetric(
                  //     vertical: kMediumPadding, horizontal: kDefaultPadding),
                  children: projects.map(buildProject).toList(),
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
            Navigator.of(context).pushNamed(AddProject.routeName);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Stream<List<Project>> readProject() => FirebaseFirestore.instance
      .collection('project')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList());
  Widget buildProject(Project project) => Container(
        padding: EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AddProject.routeName, arguments: project);
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
                // color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kItemPadding)),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.listCheck, color: Colors.teal),
                SizedBox(
                  width: kDefaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      project.user + ' status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      );
  // ListTile(
  //       leading: Text(project.name),
  //       title: Text(project.user),
  //       subtitle: Text(project.detail),
  //       onTap: () => {
  //         Navigator.of(context)
  //             .pushNamed(AddProject.routeName, arguments: project),
  //       },
  //     );
}
