import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final Dio dio;
  final _storage = FlutterSecureStorage();
  final _baseUrl = 'http://yourapi/api/v1';

  AuthRepository(this.dio);

  Future<void> init() async {
    dio.attachTokenInterceptor(this);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await dio.post(
      '$_baseUrl/login',
      data: {'username': username, 'password': password},
    );

    final data = response.data;
    await _storage.write(key: 'accessToken', value: data['accessToken']);
    await _storage.write(key: 'refreshToken', value: data['refreshToken']);
    await _storage.write(key: 'username', value: username);
    return data;
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final username = await _storage.read(key: 'username');
    final refreshToken = await _storage.read(key: 'refreshToken');

    if (username == null || refreshToken == null) {
      throw Exception('Missing credentials');
    }

    final response = await dio.post(
      '$_baseUrl/refresh',
      data: {'username': username, 'refreshToken': refreshToken},
    );

    final data = response.data;
    await _storage.write(key: 'accessToken', value: data['accessToken']);
    return data;
  }

  Future<void> logout() async => await _storage.deleteAll();

  Future<String?> get accessToken async =>
      await _storage.read(key: 'accessToken');
  Future<String?> get username async => await _storage.read(key: 'username');
}

extension DioTokenExtension on Dio {
  void attachTokenInterceptor(AuthRepository authRepo) {
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await authRepo.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              final newData = await authRepo.refreshToken();
              final newToken = newData['accessToken'];
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';

              final cloneReq = await Dio().fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            } catch (_) {
              await authRepo.logout();
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
