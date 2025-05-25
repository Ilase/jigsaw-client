import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/endpoints/endpoints.dart';

class EndpointsNotifier extends Notifier<Endpoints> {
  @override
  Endpoints build() {
    return Endpoints(scheme: "http", domain: "localhost", port: 3000);
  }

  void setEndpoints(Uri uri) {
    state = Endpoints(scheme: uri.scheme, domain: uri.host, port: uri.port);
  }
}

final endpointsProvider = NotifierProvider<EndpointsNotifier, Endpoints>(() {
  return EndpointsNotifier();
});
