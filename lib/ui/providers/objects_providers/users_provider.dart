import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/domain/entities/objects/data_state.dart';
import 'package:jigsaw_client/domain/entities/objects/user/user.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';

class UsersNotifier extends StateNotifier<DataState<List<User>>> {
  ApiRemoteDataSource apiRemoteDataSource;
  UsersNotifier({required this.apiRemoteDataSource})
    : super(DataState.loading());

  Future<void> fetchData() async {
    state = DataState.loading();
    final data = await apiRemoteDataSource.getAllUsers();
    state = DataState.data(data);
  }
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, DataState<List<User>>>((ref) {
      return UsersNotifier(
        apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
      );
    });
