import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/domain/entities/objects/data_state.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';

class ProjectsNotifier extends StateNotifier<DataState<List<Project>>> {
  ApiRemoteDataSource apiRemoteDataSource;
  ProjectsNotifier({required this.apiRemoteDataSource})
    : super(DataState.loading());

  Future<void> fetchData() async {
    state = DataState.loading();
    final data = await apiRemoteDataSource.getAllProjects();
    state = DataState.data(data);
  }

  Future<void> createProject(
    String title,
    String description,
    String readMe,
  ) async {
    apiRemoteDataSource.createProject(title, description, readMe);
  }

  Future<void> deleteProject(String title, int id) async {
    apiRemoteDataSource.deleteProject(title, id);
  }
}

final projectsProvider =
    StateNotifierProvider<ProjectsNotifier, DataState<List<Project>>>((ref) {
      return ProjectsNotifier(
        apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
      );
    });
