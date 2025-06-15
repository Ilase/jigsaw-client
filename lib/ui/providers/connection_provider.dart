import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';

class CheckConnectionNotifier extends AsyncNotifier<bool> {
  late final ApiRemoteDataSource _apiRemoteDataSource;

  @override
  FutureOr<bool> build() {
    _apiRemoteDataSource = ref.watch(apiRemoteDataSourceProvider);
    return false;
  }

  Future<void> checkConnection(Uri basePath) async {
    state = const AsyncValue.loading();
    try {
      final result = await _apiRemoteDataSource.checkConnection(basePath);
      state = AsyncValue.data(result);
      print(state.asData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final checkConnectionProvider =
    AsyncNotifierProvider<CheckConnectionNotifier, bool>(
      CheckConnectionNotifier.new,
    );
