// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Contacts 408456';

  @override
  String get appBarTitle => '408456 android_lab2';

  @override
  String get searchHint => 'Search by name';

  @override
  String get searchClear => 'Clear search';

  @override
  String get sortTooltip => 'Sort order';

  @override
  String get sortAscending => 'By name: A to Z';

  @override
  String get sortDescending => 'By name: Z to A';

  @override
  String get refreshTooltip => 'Read the address book again';

  @override
  String statsFound(int found, int total) {
    return 'Found: $found of $total';
  }

  @override
  String statsReads(int count) {
    return 'Address book reads: $count';
  }

  @override
  String get sourceSimulated => 'Source: device simulator';

  @override
  String get sourceNative => 'Source: system address book';

  @override
  String get loadingTitle => 'Reading the address book';

  @override
  String get loadingMessage =>
      'The application is requesting contacts from the system';

  @override
  String get permissionDeniedTitle => 'No access to contacts';

  @override
  String get permissionDeniedMessage =>
      'The application needs permission to read device contacts to show the list.';

  @override
  String get permissionRequestButton => 'Request access';

  @override
  String get permissionPermanentlyDeniedTitle => 'Access denied permanently';

  @override
  String get permissionPermanentlyDeniedMessage =>
      'The system no longer shows the permission request. Open the application settings and enable access to contacts manually.';

  @override
  String get permissionOpenSettingsButton => 'Open settings';

  @override
  String get emptyAddressBookTitle => 'The address book is empty';

  @override
  String get emptyAddressBookMessage =>
      'Permission is granted, but the device has no contacts.';

  @override
  String get emptySearchTitle => 'Nothing found';

  @override
  String emptySearchMessage(String query) {
    return 'No contacts match the query \"$query\".';
  }

  @override
  String get emptySearchResetButton => 'Reset search';

  @override
  String get errorTitle => 'Failed to read contacts';

  @override
  String get errorRetryButton => 'Retry';

  @override
  String get errorPermissionDenied => 'Access to contacts is not granted.';

  @override
  String get errorPermissionPermanentlyDenied =>
      'Access to contacts is denied permanently.';

  @override
  String get errorSourceUnavailable =>
      'The contacts source is not available on this platform.';

  @override
  String get errorReadFailed =>
      'The system contacts provider returned an error.';

  @override
  String get errorTimeout => 'The address book did not respond in time.';

  @override
  String get errorUnknown => 'Unknown error.';

  @override
  String errorDetails(String details) {
    return 'Technical details: $details';
  }

  @override
  String get listNoPhone => 'No phone number';

  @override
  String get listHasEmailTooltip => 'The contact has an email';

  @override
  String get detailsTitle => 'Contact';

  @override
  String get detailsPhonesSection => 'Phones';

  @override
  String get detailsEmailsSection => 'Email';

  @override
  String get detailsExtraSection => 'Additional fields';

  @override
  String get detailsOrganization => 'Organization';

  @override
  String get detailsNote => 'Note';

  @override
  String get detailsBirthday => 'Birthday';

  @override
  String get detailsIdentifier => 'Address book identifier';

  @override
  String get detailsNoPhones => 'No phone numbers';

  @override
  String get detailsNoEmails => 'No email addresses';

  @override
  String get detailsNoExtra => 'No additional fields available';

  @override
  String get detailsPlaceholder => 'Select a contact from the list';

  @override
  String get labelMobile => 'mobile';

  @override
  String get labelWork => 'work';

  @override
  String get labelHome => 'home';

  @override
  String get labelPersonal => 'personal';

  @override
  String get labelOther => 'other';

  @override
  String get systemDialogTitle =>
      'Allow \"Contacts 408456\" to access your contacts?';

  @override
  String get systemDialogMessage =>
      'The application will read names, phone numbers and email addresses from the device address book.';

  @override
  String get systemDialogAllow => 'Allow';

  @override
  String get systemDialogDeny => 'Deny';

  @override
  String get settingsTitle => 'Application settings';

  @override
  String get settingsApplicationName => 'Contacts 408456';

  @override
  String get settingsPackageName => 'ru.goltsman.android_lab2';

  @override
  String get settingsPermissionsSection => 'Permissions';

  @override
  String get settingsContactsPermission => 'Contacts';

  @override
  String get settingsAllowed => 'Allowed';

  @override
  String get settingsDenied => 'Denied';

  @override
  String get settingsHint =>
      'After returning to the application it checks the permission itself and reloads the data if needed.';

  @override
  String get settingsBack => 'Back to the application';

  @override
  String get simulatorTitle => 'Device simulator';

  @override
  String get simulatorResetPermission =>
      'Reset permission to the first launch state';

  @override
  String get simulatorRevokePermission => 'Revoke the granted permission';

  @override
  String get simulatorEmptyAddressBook => 'Make the address book empty';

  @override
  String get simulatorFillAddressBook => 'Put the contacts back';

  @override
  String get simulatorReadFailure => 'Fail the next address book read';
}
