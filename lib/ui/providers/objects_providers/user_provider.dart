import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/domain/entities/objects/data_state.dart';
import 'package:jigsaw_client/domain/entities/objects/user/user.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';

class UserNotifier extends StateNotifier<DataState<User>> {
  ApiRemoteDataSource apiRemoteDataSource;
  UserNotifier({required this.apiRemoteDataSource})
    : super(DataState.loading());

  Future<void> fetchData() async {
    state = DataState.loading();
    final data = await apiRemoteDataSource.getCurrentUserData();
    state = DataState.data(data);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, DataState<User>>((
  ref,
) {
  return UserNotifier(
    apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
  );
});
