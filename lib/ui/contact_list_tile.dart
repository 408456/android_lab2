import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../model/contact.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final bool selected;
  final VoidCallback onTap;

  const ContactListTile({
    super.key,
    required this.contact,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final phone = contact.primaryPhone;

    return ListTile(
      selected: selected,
      leading: CircleAvatar(child: Text(contact.initials)),
      title: Text(
        contact.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        phone == null ? l10n.listNoPhone : phone.number,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: phone == null
            ? theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.outline,
              )
            : null,
      ),
      trailing: contact.hasEmail
          ? Tooltip(
              message: l10n.listHasEmailTooltip,
              child: Icon(
                Icons.alternate_email,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
