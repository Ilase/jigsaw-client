import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/endpoints/endpoints.dart';
import 'package:jigsaw_client/core/router/build_route.dart';
import 'package:jigsaw_client/domain/usecase/login.dart';
import 'package:jigsaw_client/ui/pages/main/main_page.dart';
import 'package:jigsaw_client/ui/providers/auth_repository_provider.dart';
import 'package:jigsaw_client/ui/providers/connection_provider.dart';
import 'package:jigsaw_client/ui/providers/endpoints_provider.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/projects_provider.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/user_provider.dart';
import 'package:jigsaw_client/ui/providers/session_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final checkConnection = ref.watch(checkConnectionProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Jigsaw')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Login', style: textTheme.headlineMedium),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Login'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Password'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              final session = await LoginUseCase(
                                repository: ref.watch(authRepositoryProvider),
                              ).call(
                                usernameController.text,
                                passwordController.text,
                              );

                              ref.read(sessionProvider.notifier).state =
                                  session;
                              if (context.mounted) {
                                ///
                                ref.read(projectsProvider.notifier).fetchData();
                                ref.read(userProvider.notifier).fetchData();

                                ///
                                Navigator.of(context).push(
                                  createRoute(
                                    MainPage(),
                                    RouteSettings(name: '/home'),
                                  ),
                                );
                              }
                            } catch (e) {
                              ref.read(sessionProvider.notifier).state = null;

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error occurred while logging in. Check your credentials.",
                                    ),
                                  ),
                                );
                              }
                            }
                            // Navigator.of(context).push(createRoute(MainPage()));
                          },
                          label: Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 500,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Server address', style: textTheme.headlineSmall),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: ipController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Address'),
                                ),
                              ),
                            ),
                          ),
                          Text(':'),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: portController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Port'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              final checkConnection = ref.watch(
                                checkConnectionProvider,
                              );

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      final uri = Uri(
                                        scheme: "http",
                                        host: ipController.text,
                                        port: int.tryParse(portController.text),
                                        path: "api/v1/check",
                                      );

                                      await ref
                                          .read(
                                            checkConnectionProvider.notifier,
                                          )
                                          .checkConnection(uri);

                                      final result = ref.read(
                                        checkConnectionProvider,
                                      );
                                      if (result.hasValue &&
                                          result.value == true) {
                                        ref
                                            .read(endpointsProvider.notifier)
                                            .state = Endpoints(
                                          scheme: "http",
                                          domain: ipController.text,
                                          port: int.parse(portController.text),
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Connection successful',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    label: Text('Check connection'),
                                    icon: Icon(Icons.info),
                                  ),
                                  // Icon(
                                  //   checkConnection.when(
                                  //     data:
                                  //         (value) =>
                                  //             value
                                  //                 ? Icons.check_circle
                                  //                 : Icons.cancel,
                                  //     loading: () => Icons.hourglass_top,
                                  //     error: (e, st) => Icons.error,
                                  //   ),
                                  //   color: checkConnection.when(
                                  //     data:
                                  //         (value) =>
                                  //             value ? Colors.green : Colors.red,
                                  //     loading: () => Colors.grey,
                                  //     error: (e, st) => Colors.orange,
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                          // OutlinedButton.icon(
                          //   onPressed: () async {
                          //     final uri = Uri(
                          //       scheme: "http",
                          //       host: ipController.text,
                          //       port: int.tryParse(portController.text),
                          //       path: "api/v1/check",
                          //     );
                          //
                          //     await ref
                          //         .read(checkConnectionProvider.notifier)
                          //         .checkConnection(uri);
                          //
                          //     final result = ref.read(checkConnectionProvider);
                          //
                          //     if (result.hasValue && result.value == true) {
                          //       ref
                          //           .read(endpointsProvider.notifier)
                          //           .state = Endpoints(
                          //         scheme: "http",
                          //         domain: ipController.text,
                          //         port: int.parse(portController.text),
                          //       );
                          //     }
                          //     setState(() {});
                          //   },
                          //   label: Text('Check connection'),
                          //   // icon: checkConnection.when(
                          //   //   data: (value) {
                          //   //     return value
                          //   //         ? Icon(Icons.check_circle)
                          //   //         : Icon(Icons.cancel);
                          //   //   },
                          //   //   loading:
                          //   //       () => SizedBox(
                          //   //         width: 24,
                          //   //         height: 24,
                          //   //         child: CircularProgressIndicator(
                          //   //           strokeWidth: 2,
                          //   //         ),
                          //   //       ),
                          //   //   error: (e, st) => Icon(Icons.error),
                          //   // ),
                          // ),
                          // Icon(
                          //   checkConnection.when(
                          //     data: (value) {
                          //       return value
                          //           ? Icons.check_circle
                          //           : Icons.cancel;
                          //     },
                          //     loading: () => Icons.remove,
                          //     error: (e, st) => Icons.error,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
