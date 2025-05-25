import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioNotifier extends StateNotifier<Dio> {
  DioNotifier()
    : super(
        Dio(
          BaseOptions(
            connectTimeout: Duration(seconds: 10),
            receiveTimeout: Duration(seconds: 10),
          ),
        ),
      ) {
    setInterceptor();
  }
  void setInterceptor() {
    state.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {}),
    );
  }
}

final dioNotifierProvider = StateNotifierProvider<DioNotifier, Dio>((ref) {
  return DioNotifier();
});
