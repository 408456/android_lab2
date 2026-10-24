import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../service/simulated_contacts_source.dart';

class DeviceSimulatorSheet extends StatelessWidget {
  final SimulatedContactsSource source;

  const DeviceSimulatorSheet({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(l10n.simulatorTitle, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: Text(l10n.simulatorResetPermission),
            onTap: () {
              source.simulateResetPermission();

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: Text(l10n.simulatorRevokePermission),
            onTap: () {
              source.simulateRevokePermission();

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_off_outlined),
            title: Text(
              source.addressBookIsEmpty
                  ? l10n.simulatorFillAddressBook
                  : l10n.simulatorEmptyAddressBook,
            ),
            onTap: () {
              source.simulateEmptyAddressBook(!source.addressBookIsEmpty);

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_gmailerrorred_outlined),
            title: Text(l10n.simulatorReadFailure),
            onTap: () {
              source.simulateReadFailure();

              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
