class Endpoints {
  final String scheme;
  final String domain;
  final int port;
  final String basePath = 'api/v1';

  Endpoints({required this.scheme, required this.domain, required this.port});

  ///Build URI method with path compare
  Uri _build(
    String path, {
    List<String>? extraPaths,
    Map<String, String>? queryParameters,
  }) {
    final fullPath = [
      basePath,
      path,
      ...?extraPaths,
    ].where((segment) => segment.isNotEmpty).join('/');
    return Uri(
      scheme: scheme,
      host: domain,
      port: port,
      path: fullPath,
      queryParameters: queryParameters,
    );
  }

  /// Base
  Uri base({List<String> extraPaths = const [], Map<String, String>? query}) =>
      _build('', extraPaths: extraPaths, queryParameters: query);

  /// Slash
  Uri empty({List<String> extraPaths = const [], Map<String, String>? query}) =>
      _build('/check', extraPaths: extraPaths, queryParameters: query);

  ///
  /// Auth
  ///

  Uri login({List<String> extraPaths = const [], Map<String, String>? query}) =>
      _build('login', extraPaths: extraPaths, queryParameters: query);

  Uri me({List<String> extraPaths = const [], Map<String, String>? query}) =>
      _build('users/me', extraPaths: extraPaths, queryParameters: query);

  Uri users({List<String> extraPaths = const [], Map<String, String>? query}) =>
      _build('users', extraPaths: extraPaths, queryParameters: query);

  Uri register({
    List<String> extraPaths = const [],
    Map<String, String>? query,
  }) => _build('users', extraPaths: extraPaths, queryParameters: query);

  ///
  /// Objects
  ///
  Uri projects({
    List<String> extraPaths = const [],
    Map<String, String>? query,
  }) => _build('projects', extraPaths: extraPaths, queryParameters: query);
  Uri tasks({List<String> extraPaths = const [], Map<String, String>? query}) =>
      _build('tasks', extraPaths: extraPaths, queryParameters: query);
}
