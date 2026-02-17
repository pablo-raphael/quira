import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quira/core/inject/inject.dart';
import 'package:quira/core/theme/app_theme.dart';
import 'package:quira/l10n/app_localizations.dart';
import 'package:quira/layers/presentation/pages/home_page.dart';

void main() {
  Inject.init();

  runApp(
    MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    ),
  );
}
