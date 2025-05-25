import 'package:dio/dio.dart';
import 'package:jigsaw_client/core/endpoints/endpoints.dart';
import 'package:jigsaw_client/domain/entities/session.dart';

class ApiRemoteDataSource {
  Dio dio = Dio();
  Endpoints endpoints;

  ApiRemoteDataSource({required this.dio, required this.endpoints});

  Future<bool> checkConnection(Uri uri) async {
    final response = await dio.getUri(uri);
    print(response.data);
    if (response.statusCode == 200) return true;
    return false;
  }

  Future<Session> login(String username, String password) async {
    final response = await dio.postUri(
      endpoints.login(),
      data: {"username": username, "password": password},
    );
    final responseData = response.data;
    return Session(
      accessToken: responseData["accessToken"],
      refreshToken: responseData["refreshToken"],
      exp: responseData["expiresIn"],
    );
  }
}
