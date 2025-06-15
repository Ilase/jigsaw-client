import 'package:dio/dio.dart';
import 'package:jigsaw_client/core/logger/jig_logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String errorMessage =
        "StatusCode : ${err.response?.statusCode ?? "No status code"}\nMessage : ${err.message}\nResponseBody : ${err.response?.data}";
    jigLogger.e(errorMessage);
    super.onError(err, handler);
  }
}
