import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/ui/pages/login/login_page.dart';

void main() {
  runApp(ProviderScope(child: Jigsaw()));
}

class Jigsaw extends StatelessWidget {
  const Jigsaw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage(), debugShowCheckedModeBanner: false);
  }
}

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:jigsaw_client/core/data_repository.dart';
// import 'package:jigsaw_client/domain/api/auth_repoository.dart';
// import 'package:jigsaw_client/domain/locale/locale_bloc.dart';
// import 'package:jigsaw_client/pages/connect/connection_page.dart';
// import 'package:jigsaw_client/pages/home/home_page.dart';
// import 'package:jigsaw_client/pages/login/login_page.dart';
// import 'package:jigsaw_client/utils/l10n/arb/app_localizations.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final dio = Dio();
//   final authRepo = AuthRepository(dio);
//   await authRepo.init();
//   final dataRepo = DataRepository(dio);
//
//   runApp(StartPoint());
// }
//
// class StartPoint extends StatelessWidget {
//   const StartPoint({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [BlocProvider(create: (context) => LocaleBloc())],
//       child: MaterialApp(
//         localizationsDelegates: const [
//           JigsawLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//         ],
//         debugShowCheckedModeBanner: false,
//
//         supportedLocales: JigsawLocalizations.supportedLocales,
//         onGenerateTitle: (context) => JigsawLocalizations.of(context)!.appTitle,
//         home: ConnectionPage(),
//       ),
//     );
//   }
// }
