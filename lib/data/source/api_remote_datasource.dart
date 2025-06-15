import 'package:dio/dio.dart';
import 'package:jigsaw_client/core/endpoints/endpoints.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/domain/entities/objects/task/task.dart';
import 'package:jigsaw_client/domain/entities/objects/task/task_data.dart';
import 'package:jigsaw_client/domain/entities/objects/user/user.dart';
import 'package:jigsaw_client/domain/entities/session.dart';

class ApiRemoteDataSource {
  Dio dio;
  Endpoints endpoints;

  ApiRemoteDataSource({required this.dio, required this.endpoints});

  Future<bool> checkConnection(Uri uri) async {
    final response = await dio.getUri(uri);
    if (response.statusCode == 200) {
      print("Connection successful");
      return true;
    }
    return false;
  }

  Future<Session> login(String username, String password) async {
    final responseAuth = await dio.postUri(
      endpoints.login(),
      data: {"username": username, "password": password},
    );
    final responseData = responseAuth.data;
    // print("RESPONSE AUTH: ${responseAuth.data}");
    // print("Parsed values:");
    // print("accessToken: ${responseData["accessToken"]}");
    // print("refreshToken: ${responseData["refreshToken"]}");
    // print("expiresIn: ${responseData["expiresIn"]}");
    return Session(
      accessToken: responseData["accessToken"],
      refreshToken: responseData["refreshToken"],
      exp: responseData["expiresIn"],
    );
  }

  Future<List<User>> getAllUsers() async {
    final response = await dio.getUri(endpoints.users());
    List<dynamic> rawData = response.data['users'];
    List<User> users = rawData.map((e) => User.fromJson(e)).toList();
    return users;
  }

  Future<List<Project>> getAllProjects() async {
    final response = await dio.getUri(endpoints.projects());
    List<dynamic> rawData = response.data['projects'];
    List<Project> projects = rawData.map((e) => Project.fromJson(e)).toList();
    return projects;
  }

  Future<User> getCurrentUserData() async {
    final response = await dio.getUri(endpoints.me());
    final User user = User.fromJson(response.data);
    return user;
  }

  Future<void> createProject(
    String title,
    String description,
    String readMe,
  ) async {
    try {
      final response = await dio.postUri(
        endpoints.projects(),
        data: {"title": title, "description": description, "readMe": readMe},
      );
    } catch (e) {
      throw Exception('Error occurred while creating project');
    }
  }

  Future<void> deleteProject(String title, int id) async {
    try {
      final response = await dio.deleteUri(
        endpoints.projects(extraPaths: [id.toString()]),
        data: {"title": title},
      );
    } catch (e) {
      throw Exception('Error occurred while deleting project');
    }
  }

  Future<TaskData> getProjectTasks(int id) async {
    try {
      final response = await dio.getUri(
        endpoints.projects(extraPaths: [id.toString(), "tasks"]),
      );
      print(response.data);
      final TaskData rawData = TaskData.fromJson(response.data);
      return rawData;
    } catch (e) {
      print(e.toString());
      throw Exception('Error occurred while fetching project tasks');
    }
  }

  Future<TaskData> updateTask(Task updatedTask, int projectId) async {
    try {
      final response = await dio.patchUri(
        endpoints.tasks(extraPaths: [updatedTask.id.toString()]),
        data: {
          "title": updatedTask.title,
          "status": updatedTask.status,
          "description": updatedTask.title,
        },
      );
      Future.delayed(Duration(milliseconds: 200));
      return await getProjectTasks(projectId);
    } catch (e) {
      print(e.toString());
      throw Exception('Error occurred while updating project tasks');
    }
  }

  Future<void> createTask(String title, String status, int projectId) async {
    try {
      final response = await dio.postUri(
        endpoints.projects(extraPaths: [projectId.toString(), "tasks"]),
        data: {"title": title, "status": status},
      );
      Future.delayed(Duration(milliseconds: 200));
    } catch (e) {
      print(e.toString());
      throw Exception('Error occurred while updating project tasks');
    }
  }
}
