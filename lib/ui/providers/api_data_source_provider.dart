import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/repositories_impl/auth_repository_impl.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/ui/providers/dio_provider.dart';
import 'package:jigsaw_client/ui/providers/endpoints_notifier.dart';

final apiRemoteRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.watch(apiRemoteDataSourceProvider)),
);

final apiRemoteDataSourceProvider = Provider((ref) {
  return ApiRemoteDataSource(
    dio: ref.read(dioNotifierProvider),
    endpoints: ref.read(endpointsProvider),
  );
});
