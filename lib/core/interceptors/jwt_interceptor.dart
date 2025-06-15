import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/domain/entities/session.dart';
import 'package:jigsaw_client/ui/providers/session_provider.dart';

class JwtInterceptor extends Interceptor {
  final Ref ref;

  JwtInterceptor({required this.ref});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Session? session = ref.watch(sessionProvider);
    if (session != null) {
      print("Session: ${session.accessToken}");
      options.headers["Authorization"] = 'Bearer ${session.accessToken}';
      print(options.headers["Authorization"]);
    }
    super.onRequest(options, handler);
  }
}
