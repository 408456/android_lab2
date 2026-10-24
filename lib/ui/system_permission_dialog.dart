import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../service/contacts_source.dart';
import '../utils/contacts_logger.dart';

class SystemPermissionDialogGateway implements PermissionDialogGateway {
  final GlobalKey<NavigatorState> navigatorKey;
  final ContactsLogger logger;

  SystemPermissionDialogGateway({
    required this.navigatorKey,
    required this.logger,
  });

  @override
  Future<bool> askContactsPermission() async {
    final context = navigatorKey.currentContext;

    if (context == null) {
      logger.logWarning(
        'системный диалог не показан: навигатор ещё не построен',
      );

      return false;
    }

    logger.logAction('показан системный диалог запроса разрешения');

    final granted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const SystemPermissionDialog(),
    );

    logger.logAction('ответ пользователя в системном диалоге: $granted');

    return granted ?? false;
  }
}

class SystemPermissionDialog extends StatelessWidget {
  const SystemPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      icon: const Icon(Icons.contacts_outlined, size: 32),
      title: Text(
        l10n.systemDialogTitle,
        style: const TextStyle(fontSize: 18),
      ),
      content: Text(l10n.systemDialogMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.systemDialogDeny),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.systemDialogAllow),
        ),
      ],
    );
  }
}
