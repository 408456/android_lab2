import '../l10n/app_localizations.dart';

class ContactLabels {
  static String translate(AppLocalizations l10n, String label) {
    switch (label) {
      case 'mobile':
        return l10n.labelMobile;

      case 'work':
        return l10n.labelWork;

      case 'home':
        return l10n.labelHome;

      case 'personal':
        return l10n.labelPersonal;
    }

    return l10n.labelOther;
  }
}
