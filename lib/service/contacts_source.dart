import '../model/contact.dart';
import '../model/contacts_state.dart';

abstract class ContactsSource {
  String get name;

  bool get isSimulated;

  Future<ContactsPermissionStatus> checkPermission();

  Future<ContactsPermissionStatus> requestPermission();

  Future<bool> openAppSettings();

  Future<List<Contact>> readContacts();
}

abstract class PermissionDialogGateway {
  Future<bool> askContactsPermission();
}
