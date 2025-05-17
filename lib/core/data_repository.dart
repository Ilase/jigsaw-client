import 'package:dio/dio.dart';
import 'package:jigsaw_client/domain/api/auth_repoository.dart';

class DataRepository {
  final Dio dio;

  DataRepository(this.dio);

  Future<List<dynamic>> fetchUsers() async {
    final response = await dio.get('http://yourapi/api/v1/users');
    return response.data['users'];
  }

  Future<List<dynamic>> fetchProjects() async {
    final response = await dio.get('http://yourapi/api/v1/projects');
    return response.data['projects'];
  }
}
