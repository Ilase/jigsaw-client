import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/tab_data/tab_data.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/ui/pages/project/tabs/kanban_list_view.dart';
import 'package:jigsaw_client/ui/pages/project/tabs/task_list_view.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/project_data_notifier.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/projects_provider.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/users_provider.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class ProjectPage extends ConsumerStatefulWidget {
  const ProjectPage({super.key});

  @override
  ConsumerState<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final Project project;

  List<TabData> tabs = [TabData(title: 'List View', content: TaskListView())];

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   project = ModalRoute.of(context)!.settings.arguments as Project;
  //
  //   projectTaskData ??=
  //       StateNotifierProvider<ProjectDataNotifier, DataState<TaskData>>((ref) {
  //         return ProjectDataNotifier(
  //           apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
  //         );
  //       });
  //
  //   ref.read(projectTaskData!.notifier).fetchData(project.id);
  // }

  @override
  void initState() {
    super.initState();

    _initController();
  }

  void _initController() {
    // projectTaskData =
    //     StateNotifierProvider<ProjectDataNotifier, DataState<TaskData>>((ref) {
    //       return ProjectDataNotifier(
    //         apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
    //       );
    //     });
    //
    // ref.read(projectTaskData.notifier).fetchData(project.id);
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void _addTab(TabData newTab) {
    setState(() {
      tabs.add(newTab);
      _initController();
    });
  }

  void _removeTab(int index) {
    if (tabs.length <= 1) return;
    setState(() {
      tabs.removeAt(index);
      _initController();
    });
  }

  void _renameTab(int index) async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempName = tabs[index].title;
        return AlertDialog(
          title: Text('Rename tab'),
          content: TextField(
            autofocus: true,
            controller: TextEditingController(text: tempName),
            onChanged: (value) => tempName = value,
            decoration: InputDecoration(
              labelText: 'New name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(tempName),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.trim().isNotEmpty) {
      setState(() {
        tabs[index].title = newName.trim();
      });
    }
  }

  Widget _buildTab(int index) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tabs[index].title),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'rename') {
                _renameTab(index);
              } else if (value == 'delete') {
                _removeTab(index);
              }
            },
            itemBuilder:
                (_) => [
                  PopupMenuItem(value: 'rename', child: Text('Переименовать')),
                  PopupMenuItem(value: 'delete', child: Text('Удалить')),
                ],
            icon: Icon(Icons.more_vert, size: 18),
          ),
        ],
      ),
    );
  }

  void _showAddTabMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy,
      ),
      items: [
        PopupMenuItem(value: 'kanban', child: Text('Kanban Tab')),
        PopupMenuItem(value: 'list', child: Text('List Tab')),
        // PopupMenuItem(value: 'custom', child: Text('Custom Tab')),
      ],
    );

    if (selected != null) {
      if (selected == 'kanban') {
        _addTab(
          TabData(
            title: 'Kanban View ${tabs.length + 1}',
            content: KanbanListView(),
          ),
        );
      } else if (selected == 'list') {
        _addTab(
          TabData(
            title: 'List View ${tabs.length + 1}',
            content: TaskListView(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as Project;
    final projectTaskDataState = ref.watch(projectDataStateNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: [
            Text(project.title, style: textTheme.titleLarge),
            Text(project.description, style: textTheme.titleSmall),
            Divider(),
            Expanded(child: MarkdownParse(data: project.readMe)),
          ],
        ),
      ),

      appBar: AppBar(title: Text(project.title)),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Collaborators', style: textTheme.titleMedium),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children:
                            project.collaborators
                                .map((e) => Chip(label: Text(e)))
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(projectDataStateNotifierProvider.notifier)
                            .fetchData(project.id);
                      },
                      icon: Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) =>
                                  AddUsersDialog(projectId: project.id),
                        );
                      },
                      icon: Icon(Icons.person_add),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteProjectDialog(
                              projectId: project.id,
                              projectTitle: project.title,
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child:
                projectTaskDataState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : projectTaskDataState.error != null
                    ? Center(child: Icon(Icons.error))
                    : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                tabs: List.generate(tabs.length, _buildTab),
                              ),
                            ),
                            Builder(
                              builder:
                                  (context) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: () => _showAddTabMenu(context),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: tabs.map((tab) => tab.content).toList(),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}

class DeleteProjectDialog extends ConsumerWidget {
  const DeleteProjectDialog({
    super.key,
    required this.projectTitle,
    required this.projectId,
  });
  final int projectId;
  final String projectTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    return AlertDialog(
      title: Text("Delete project"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Type full name of the project.'),
          Chip(label: Text(projectTitle)),
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
                  .deleteProject(projectTitle, projectId);
              ref.read(projectsProvider.notifier).fetchData();
              Navigator.of(context).popUntil(ModalRoute.withName('/home'));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error occurred while creating project'),
                ),
              );
            }
          },
          child: Text("Delete"),
        ),
      ],
    );
  }
}

class AddUsersDialog extends ConsumerStatefulWidget {
  final int projectId;
  const AddUsersDialog({super.key, required this.projectId});

  @override
  ConsumerState<AddUsersDialog> createState() => _AddUsersDialogState();
}

class _AddUsersDialogState extends ConsumerState<AddUsersDialog> {
  final Set<String> selectedUserNicknames = {};

  @override
  void initState() {
    super.initState();
    ref.read(usersProvider.notifier).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

    return AlertDialog(
      title: Text('Add users to project'),
      content:
          usersState.isLoading
              ? Center(child: CircularProgressIndicator())
              : usersState.error != null
              ? Text('Error loading users')
              : SizedBox(
                width: 300,
                height: 400,
                child: ListView(
                  children:
                      usersState.data!
                          .map(
                            (user) => CheckboxListTile(
                              title: Text(user.nickname),
                              subtitle: Text('${user.fName} ${user.lName}'),
                              value: selectedUserNicknames.contains(
                                user.nickname,
                              ),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    selectedUserNicknames.add(user.nickname);
                                  } else {
                                    selectedUserNicknames.remove(user.nickname);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              usersState.isLoading
                  ? null
                  : () async {
                    // Обновить проект, если надо
                    ref
                        .read(projectDataStateNotifierProvider.notifier)
                        .fetchData(widget.projectId);

                    Navigator.pop(context);
                  },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
