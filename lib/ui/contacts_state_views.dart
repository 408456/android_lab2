import 'package:flutter/material.dart';

import '../exception/contacts_exception_handler.dart';
import '../l10n/app_localizations.dart';
import '../model/contacts_state.dart';

class ContactsMessageView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? details;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ContactsMessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.details,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              if (details != null) ...[
                const SizedBox(height: 10),
                Text(
                  details!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ContactsLoadingView extends StatelessWidget {
  const ContactsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 18),
          Text(l10n.loadingTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(l10n.loadingMessage, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class ContactsErrorMessages {
  static String describe(AppLocalizations l10n, ContactsErrorCode code) {
    switch (code) {
      case ContactsErrorCode.permissionDenied:
        return l10n.errorPermissionDenied;

      case ContactsErrorCode.permissionPermanentlyDenied:
        return l10n.errorPermissionPermanentlyDenied;

      case ContactsErrorCode.sourceUnavailable:
        return l10n.errorSourceUnavailable;

      case ContactsErrorCode.readFailed:
        return l10n.errorReadFailed;

      case ContactsErrorCode.timeout:
        return l10n.errorTimeout;

      case ContactsErrorCode.unknown:
        return l10n.errorUnknown;
    }
  }
}

class ContactsErrorView extends StatelessWidget {
  final ContactsFailure? failure;
  final VoidCallback onRetry;

  const ContactsErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final code = failure?.code ?? ContactsErrorCode.unknown;

    return ContactsMessageView(
      icon: Icons.error_outline,
      title: l10n.errorTitle,
      message: ContactsErrorMessages.describe(l10n, code),
      details: failure == null
          ? null
          : l10n.errorDetails(failure!.technicalMessage),
      actionLabel: l10n.errorRetryButton,
      onAction: onRetry,
    );
  }
}

class ContactsPermissionDeniedView extends StatelessWidget {
  final VoidCallback onRequest;

  const ContactsPermissionDeniedView({super.key, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ContactsMessageView(
      icon: Icons.lock_outline,
      title: l10n.permissionDeniedTitle,
      message: l10n.permissionDeniedMessage,
      actionLabel: l10n.permissionRequestButton,
      onAction: onRequest,
    );
  }
}

class ContactsPermissionPermanentlyDeniedView extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const ContactsPermissionPermanentlyDeniedView({
    super.key,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ContactsMessageView(
      icon: Icons.settings_outlined,
      title: l10n.permissionPermanentlyDeniedTitle,
      message: l10n.permissionPermanentlyDeniedMessage,
      actionLabel: l10n.permissionOpenSettingsButton,
      onAction: onOpenSettings,
    );
  }
}

class ContactsEmptyAddressBookView extends StatelessWidget {
  const ContactsEmptyAddressBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ContactsMessageView(
      icon: Icons.person_off_outlined,
      title: l10n.emptyAddressBookTitle,
      message: l10n.emptyAddressBookMessage,
    );
  }
}

class ContactsEmptySearchView extends StatelessWidget {
  final String query;
  final VoidCallback onReset;

  const ContactsEmptySearchView({
    super.key,
    required this.query,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ContactsMessageView(
      icon: Icons.search_off,
      title: l10n.emptySearchTitle,
      message: l10n.emptySearchMessage(query),
      actionLabel: l10n.emptySearchResetButton,
      onAction: onReset,
    );
  }
}
