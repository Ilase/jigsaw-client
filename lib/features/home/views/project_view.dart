import 'package:flutter/material.dart';
import 'package:jigsaw_client/features/project/project_page.dart';
import 'package:jigsaw_client/utils/const/router/router.dart';

/// List of project available for user
class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              buildRoute(
                ProjectPage(),
                RouteSettings(
                  name: "/project/$index",
                  arguments: {"project_id": index},
                ),
              ),
            );
          },
          child: Card(color: Colors.grey, child: Text("Project $index")),
        );
      },
    );
  }
}
