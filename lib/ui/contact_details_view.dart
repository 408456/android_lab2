import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../model/contact.dart';
import 'contact_labels.dart';

class ContactDetailsView extends StatelessWidget {
  final Contact contact;

  const ContactDetailsView({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Row(
          children: [
            CircleAvatar(radius: 28, child: Text(contact.initials)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                contact.displayName,
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          title: l10n.detailsPhonesSection,
          icon: Icons.phone_outlined,
          emptyText: l10n.detailsNoPhones,
          values: contact.phones
              .map(
                (phone) => _DetailsValue(
                  label: ContactLabels.translate(l10n, phone.label),
                  value: phone.number,
                ),
              )
              .toList(),
        ),
        _buildSection(
          context,
          title: l10n.detailsEmailsSection,
          icon: Icons.alternate_email,
          emptyText: l10n.detailsNoEmails,
          values: contact.emails
              .map(
                (email) => _DetailsValue(
                  label: ContactLabels.translate(l10n, email.label),
                  value: email.address,
                ),
              )
              .toList(),
        ),
        _buildSection(
          context,
          title: l10n.detailsExtraSection,
          icon: Icons.info_outline,
          emptyText: l10n.detailsNoExtra,
          values: _buildExtraValues(l10n),
        ),
      ],
    );
  }

  List<_DetailsValue> _buildExtraValues(AppLocalizations l10n) {
    final values = <_DetailsValue>[];

    if (contact.organization != null) {
      values.add(
        _DetailsValue(
          label: l10n.detailsOrganization,
          value: contact.organization!,
        ),
      );
    }

    if (contact.birthday != null) {
      values.add(
        _DetailsValue(
          label: l10n.detailsBirthday,
          value: contact.birthday!,
        ),
      );
    }

    if (contact.note != null) {
      values.add(
        _DetailsValue(label: l10n.detailsNote, value: contact.note!),
      );
    }

    values.add(
      _DetailsValue(label: l10n.detailsIdentifier, value: contact.id),
    );

    return values;
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String emptyText,
    required List<_DetailsValue> values,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            if (values.isEmpty)
              Text(
                emptyText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.outline,
                ),
              ),
            for (final item in values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SelectableText(
                      item.value,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailsValue {
  final String label;
  final String value;

  _DetailsValue({required this.label, required this.value});
}

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailsScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailsTitle)),
      body: SafeArea(child: ContactDetailsView(contact: contact)),
    );
  }
}

class ContactDetailsPlaceholder extends StatelessWidget {
  const ContactDetailsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.contact_page_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.detailsPlaceholder,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
