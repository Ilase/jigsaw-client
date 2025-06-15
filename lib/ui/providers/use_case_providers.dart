import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/domain/usecase/login.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';

final loginProvider = Provider((ref) {
  return LoginUseCase(repository: ref.watch(authRepositoryProvider));
});
