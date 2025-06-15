import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/interceptors/error_interceptor.dart';
import 'package:jigsaw_client/core/interceptors/jwt_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  Dio dio = Dio(
    BaseOptions(
      receiveTimeout: Duration(seconds: 10),
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(JwtInterceptor(ref: ref));
  dio.interceptors.add(ErrorInterceptor());
  return dio;
});
