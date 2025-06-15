import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/domain/entities/objects/task/task.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/project_data_notifier.dart';

class KanbanListView extends ConsumerStatefulWidget {
  const KanbanListView({super.key});

  @override
  ConsumerState<KanbanListView> createState() => _KanbanListViewState();
}

class _KanbanListViewState extends ConsumerState<KanbanListView> {
  late final TextEditingController _todoController;
  late final TextEditingController _inProgressController;
  late final TextEditingController _doneController;

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController();
    _inProgressController = TextEditingController();
    _doneController = TextEditingController();
  }

  @override
  void dispose() {
    _todoController.dispose();
    _inProgressController.dispose();
    _doneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = ref.watch(projectDataStateNotifierProvider);
    final project = ModalRoute.of(context)!.settings.arguments as Project;

    // Group tasks by status
    final todoTasks =
        tasksData.data!.tasks.where((task) => task.status == 'todo').toList();
    final inProgressTasks =
        tasksData.data!.tasks
            .where((task) => task.status == 'in_progress')
            .toList();
    final doneTasks =
        tasksData.data!.tasks.where((task) => task.status == 'done').toList();
    return tasksData.isLoading
        ? Center(child: CircularProgressIndicator())
        : tasksData.error != null
        ? Center(child: Icon(Icons.error))
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Todo Column
              Expanded(
                child: _buildKanbanColumn(
                  "Todo",
                  todoTasks,
                  'todo',
                  tasksData,
                  project.id,
                  _todoController,
                ),
              ),
              VerticalDivider(),
              // In Progress Column
              Expanded(
                child: _buildKanbanColumn(
                  "In Progress",
                  inProgressTasks,
                  'in_progress',
                  tasksData,
                  project.id,
                  _inProgressController,
                ),
              ),
              VerticalDivider(),
              // Done Column
              Expanded(
                child: _buildKanbanColumn(
                  "Done",
                  doneTasks,
                  'done',
                  tasksData,
                  project.id,
                  _doneController,
                ),
              ),
              // Expanded(child: ''),
            ],
          ),
        );
  }

  Widget _buildKanbanColumn(
    String title,
    List<Task> tasks,
    String status,
    tasksData,
    int projectId,
    TextEditingController controller,
  ) {
    return DragTarget<Task>(
      onAcceptWithDetails: (details) {
        final task = details.data;
        final updatedTask = task.copyWith(status: status);

        Future.microtask(() {
          ref
              .read(projectDataStateNotifierProvider.notifier)
              .updateTask(updatedTask, projectId);
          ref
              .read(projectDataStateNotifierProvider.notifier)
              .fetchData(projectId);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  ...tasks
                      .map((task) => _buildDraggableTaskCard(task))
                      .toList(),
                ],
              ),
            ),
            Divider(),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'New task title',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(),
              ),
              onEditingComplete: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  ref
                      .read(projectDataStateNotifierProvider.notifier)
                      .createTask(title, status, projectId);
                  controller.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableTaskCard(Task task) {
    return Draggable<Task>(
      data: task,
      feedback: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(task.id.toString())),
              title: Text(task.title),
              subtitle: Text(task.body ?? "No content"),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(task.id.toString())),
            title: Text(task.title),
            subtitle: Text(task.body ?? "No content"),
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(child: Text(task.id.toString())),
          title: Text(task.title),
          subtitle: Text(task.body ?? "No content"),
        ),
      ),
    );
  }
}
