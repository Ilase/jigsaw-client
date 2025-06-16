import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/project_data_notifier.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView> {
  TextEditingController taskTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as Project;
    final tasksData = ref.watch(projectDataStateNotifierProvider);
    return tasksData.isLoading
        ? Center(child: CircularProgressIndicator())
        : tasksData.error != null
        ? Center(child: Icon(Icons.error))
        : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasksData.data!.tasks.length,
                itemBuilder: (builder, index) {
                  final task = tasksData.data!.tasks[index];
                  return ListTile(
                    leading: Text(task.id.toString()),
                    title: Text(task.title),
                    subtitle: Text(task.body ?? "No content"),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: taskTitleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Add task'),
                ),
                onEditingComplete: () {
                  final title = taskTitleController.text.trim();
                  if (title.isNotEmpty) {
                    ref
                        .read(projectDataStateNotifierProvider.notifier)
                        .createTask(title, "todo", project.id);
                    taskTitleController.clear();
                  }
                },
              ),
            ),
          ],
        );
  }
}
