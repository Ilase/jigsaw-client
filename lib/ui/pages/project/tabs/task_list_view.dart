import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/domain/entities/objects/task/task.dart';
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
                    onTap: () => _showTaskDialog(context, task, project.id),
                    leading: Text("ID: ${task.id}"),
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

  void _showTaskDialog(BuildContext context, Task task, int projectId) {
    final titleController = TextEditingController(text: task.title);
    final bodyController = TextEditingController(text: task.body ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Body',
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ref
                          .read(projectDataStateNotifierProvider.notifier)
                          .updateTask(
                            task.copyWith(
                              title: titleController.text.trim(),
                              body: bodyController.text.trim(),
                            ),
                            projectId,
                          );
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.save),
                    label: Text("Сохранить"),
                  ),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(projectDataStateNotifierProvider.notifier)
                          .deleteTask(task.id, projectId);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Удалить"),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
