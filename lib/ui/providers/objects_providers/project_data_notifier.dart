import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/domain/entities/objects/data_state.dart';
import 'package:jigsaw_client/domain/entities/objects/task/task.dart';
import 'package:jigsaw_client/domain/entities/objects/task/task_data.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';

class ProjectDataNotifier extends StateNotifier<DataState<TaskData>> {
  ApiRemoteDataSource apiRemoteDataSource;
  ProjectDataNotifier({required this.apiRemoteDataSource})
    : super(DataState.loading());

  Future<void> fetchData(int projectId) async {
    try {
      state = DataState.loading();
      final data = await apiRemoteDataSource.getProjectTasks(projectId);
      state = DataState.data(data);
    } catch (e) {
      print(e.toString());
      state = DataState.error(e.toString());
    }
  }

  Future<void> updateTask(Task updatedTask, int projectId) async {
    apiRemoteDataSource.updateTask(updatedTask, projectId);
    await fetchData(projectId);
  }

  Future<void> createTask(String title, String status, int projectId) async {
    apiRemoteDataSource.createTask(title, status, projectId);
    await fetchData(projectId);
  }

  Future<void> deleteTask(int taskId, int projectId) async {
    apiRemoteDataSource.deleteTask(taskId);
    await fetchData(projectId);
  }

  Future<void> addUsersToProject(
    Set<String> selectedUsers,
    int projectId,
  ) async {
    apiRemoteDataSource.addUsersToProject(selectedUsers, projectId);
    await fetchData(projectId);
  }
}

final projectDataStateNotifierProvider =
    StateNotifierProvider<ProjectDataNotifier, DataState<TaskData>>((ref) {
      return ProjectDataNotifier(
        apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
      );
    });
