import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/project_data_notifier.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  // final TabData tabData;

  @override
  ConsumerState<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView> {
  @override
  Widget build(BuildContext context) {
    final tasksData = ref.watch(projectDataStateNotifierProvider);
    return tasksData.isLoading
        ? Center(child: CircularProgressIndicator())
        : tasksData.error != null
        ? Center(child: Icon(Icons.error))
        : ListView.builder(
          itemCount: tasksData.data!.tasks.length,
          itemBuilder: (builder, index) {
            final task = tasksData.data!.tasks[index];
            return ListTile(
              leading: Text(task.id.toString()),
              title: Text(task.title),
              subtitle: Text(task.body ?? "No content"),
            );
          },
        );
  }
}
