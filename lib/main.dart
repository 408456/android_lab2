import 'dart:async';

import 'package:flutter/material.dart';

import 'controller/contacts_controller.dart';
import 'exception/contacts_exception_handler.dart';
import 'l10n/app_localizations.dart';
import 'service/contacts_source.dart';
import 'service/contacts_source_factory.dart';
import 'service/simulated_contacts_source.dart';
import 'ui/contacts_screen.dart';
import 'ui/system_permission_dialog.dart';
import 'utils/contacts_logger.dart';

void main() {
  const logger = ContactsLogger('App');

  final handler = ContactsExceptionHandler(logger.child('Handler'));

  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        handler.handleFatal(
          details.exception,
          details.stack ?? StackTrace.current,
          source: 'FlutterError.onError',
        );
      };

      logger.logAction('запуск приложения');

      final navigatorKey = GlobalKey<NavigatorState>();

      final ContactsSource source = ContactsSourceFactory.create(logger);

      if (source is SimulatedContactsSource) {
        source.dialogGateway = SystemPermissionDialogGateway(
          navigatorKey: navigatorKey,
          logger: logger.child('SystemDialog'),
        );
      }

      final controller = ContactsController(
        source: source,
        handler: handler,
        logger: logger.child('Controller'),
      );

      runApp(
        ContactsApp(navigatorKey: navigatorKey, controller: controller),
      );
    },
    (error, stackTrace) {
      handler.handleFatal(error, stackTrace, source: 'runZonedGuarded');
    },
  );
}

class ContactsApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ContactsController controller;

  const ContactsApp({
    super.key,
    required this.navigatorKey,
    required this.controller,
  });

  @override
  State<ContactsApp> createState() => _ContactsAppState();
}

class _ContactsAppState extends State<ContactsApp> {
  static const ContactsLogger logger = ContactsLogger('App.Root');

  Locale locale = const Locale('ru');

  void onLocaleToggled() {
    setState(() {
      locale = locale.languageCode == 'ru'
          ? const Locale('en')
          : const Locale('ru');
    });

    logger.logAction('язык интерфейса переключён на ${locale.languageCode}');
  }

  @override
  void dispose() {
    widget.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: widget.navigatorKey,

      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,

      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      theme: ThemeData(
        brightness: Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
      ),

      home: ContactsScreen(
        controller: widget.controller,
        locale: locale,
        onLocaleToggled: onLocaleToggled,
      ),
    );
  }
}
