import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:identity/core/design/theme/app_theme.dart';
import '../core/l10n/app_localizations.dart';
import '../core/l10n/locale_cubit.dart';
import 'navigation/app_pages.dart';

class AppRoot extends StatelessWidget {
  final String initialRoute;

  const AppRoot({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return GetMaterialApp(
          key: ValueKey(locale.languageCode),
          debugShowCheckedModeBanner: false,
          title: AppLocalizations.of(context)?.appTitle ?? 'Identity Admin',
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es'), Locale('ar')],
          // theme: _buildThemeWithPoppins(themeController.currentTheme),
          theme: AppTheme.appTheme,
          // theme: AppTheme.dentalTheme,
          themeMode: ThemeMode.system,
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          unknownRoute: GetPage(
            name: '/notfound',
            page: () => const Scaffold(body: Center(child: Text('404'))),
          ),
        );
      },
    );
  }

  // ThemeData _buildThemeWithPoppins(ThemeData originalTheme) {
  //   return originalTheme.copyWith(
  //     elevatedButtonTheme: AppTheme.dentalTheme.elevatedButtonTheme,
  //     actionIconTheme: AppTheme.dentalTheme.actionIconTheme,
  //     inputDecorationTheme: AppTheme.dentalTheme.inputDecorationTheme,
  //     cardTheme: AppTheme.dentalTheme.cardTheme,
  //     dividerTheme: AppTheme.dentalTheme.dividerTheme,
  //     appBarTheme: AppTheme.dentalTheme.appBarTheme,
  //     textTheme: GoogleFonts.poppinsTextTheme(originalTheme.textTheme),
  //   );
  // }
}
