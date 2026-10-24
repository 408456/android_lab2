import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../model/contacts_state.dart';
import '../service/simulated_contacts_source.dart';

class AppSettingsScreen extends StatefulWidget {
  final SimulatedContactsSource source;

  const AppSettingsScreen({super.key, required this.source});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late bool granted;

  @override
  void initState() {
    super.initState();

    granted = widget.source.currentPermission.isGranted;

    widget.source.logger.logAction(
      'открыт экран настроек приложения, разрешение: $granted',
    );
  }

  void onPermissionChanged(bool value) {
    setState(() {
      granted = value;
    });

    widget.source.setPermissionFromSettings(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.contacts)),
              title: Text(l10n.settingsApplicationName),
              subtitle: Text(l10n.settingsPackageName),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.settingsPermissionsSection,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SwitchListTile(
              value: granted,
              onChanged: onPermissionChanged,
              secondary: const Icon(Icons.perm_contact_calendar_outlined),
              title: Text(l10n.settingsContactsPermission),
              subtitle: Text(
                granted ? l10n.settingsAllowed : l10n.settingsDenied,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.settingsHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.settingsBack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
