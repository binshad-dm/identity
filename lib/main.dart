import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/navigation/routes.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SemanticsBinding.instance.ensureSemantics();
  });
  runApp(
    BlocProvider<LocaleCubit>(
      create: (context) => LocaleCubit(sl<SharedPreferences>()),
      child: const AppRoot(initialRoute: AppRoutes.dashboard),
    ),
  );
}
