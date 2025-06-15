import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/router/build_route.dart';
import 'package:jigsaw_client/ui/pages/main/destinations/create_project_page.dart';
import 'package:jigsaw_client/ui/pages/main/widgets/project_card.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/projects_provider.dart';

class ProjectView extends ConsumerStatefulWidget {
  const ProjectView({super.key});

  @override
  ConsumerState createState() => _ProjectViewState();
}

class _ProjectViewState extends ConsumerState<ProjectView> {
  @override
  Widget build(BuildContext context) {
    final projectData = ref.watch(projectsProvider);
    return Center(
      child: Column(
        children: [
          Column(),
          Divider(),
          searchBar(),
          Expanded(
            child:
                projectData.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : projectData.error != null
                    ? Center(child: Icon(Icons.error))
                    : ListView.builder(
                      itemCount: projectData.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final project = projectData.data![index];
                        return ProjectCard(project: project);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  searchBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(projectsProvider.notifier).fetchData();
              },
              icon: Icon(Icons.refresh),
            ),
            Expanded(child: TextField()),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    CreateProjectPage(),
                    RouteSettings(name: '/create-project'),
                  ),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) => CreateProjectDialog(),
                // );
              },
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateProjectDialog extends ConsumerWidget {
  const CreateProjectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return AlertDialog(
      title: Text("Create project"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Title'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Description'),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            try {
              ref
                  .read(projectsProvider.notifier)
                  .createProject(
                    titleController.text,
                    descriptionController.text,
                    '',
                  );
              Navigator.of(context).pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error occurred while creating project'),
                ),
              );
            }
          },
          child: Text("Create"),
        ),
      ],
    );
  }
}
