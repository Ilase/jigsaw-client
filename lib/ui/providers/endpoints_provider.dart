import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/endpoints/endpoints.dart';

final endpointsProvider = StateProvider<Endpoints>((ref) {
  return Endpoints(scheme: 'http', domain: "localhost", port: 8090);
});
