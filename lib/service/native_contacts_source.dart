import 'package:flutter/services.dart';

import '../exception/contacts_exception.dart';
import '../model/contact.dart';
import '../model/contacts_state.dart';
import '../utils/contacts_logger.dart';
import 'contacts_source.dart';

class NativeContactsSource implements ContactsSource {
  static const MethodChannel channel = MethodChannel(
    'ru.goltsman.android_lab2/contacts',
  );

  static const Duration readTimeout = Duration(seconds: 15);

  final ContactsLogger logger;

  NativeContactsSource({required this.logger});

  @override
  String get name => 'NativeContactsSource';

  @override
  bool get isSimulated => false;

  @override
  Future<ContactsPermissionStatus> checkPermission() async {
    logger.logPlatform('MethodChannel.checkPermission');

    final result = await channel.invokeMethod<String>('checkPermission');

    return _parsePermission(result);
  }

  @override
  Future<ContactsPermissionStatus> requestPermission() async {
    logger.logPlatform('MethodChannel.requestPermission');

    final result = await channel.invokeMethod<String>('requestPermission');

    return _parsePermission(result);
  }

  @override
  Future<bool> openAppSettings() async {
    logger.logPlatform('MethodChannel.openAppSettings');

    final result = await channel.invokeMethod<bool>('openAppSettings');

    return result ?? false;
  }

  @override
  Future<List<Contact>> readContacts() async {
    logger.logPlatform('MethodChannel.readContacts');

    final stopwatch = Stopwatch()..start();

    final result = await channel
        .invokeMethod<List<Object?>>('readContacts')
        .timeout(readTimeout);

    stopwatch.stop();

    if (result == null) {
      throw ContactsReadException('платформа не вернула список контактов');
    }

    final contacts = result
        .whereType<Map<Object?, Object?>>()
        .map(Contact.fromMap)
        .toList();

    logger.logPlatform('платформа вернула записей: ${contacts.length}');
    logger.logDuration('чтение адресной книги', stopwatch.elapsed);

    return contacts;
  }

  ContactsPermissionStatus _parsePermission(String? value) {
    switch (value) {
      case 'granted':
        return ContactsPermissionStatus.granted;

      case 'denied':
        return ContactsPermissionStatus.denied;

      case 'permanentlyDenied':
        return ContactsPermissionStatus.permanentlyDenied;
    }

    logger.logWarning('неизвестный статус разрешения от платформы: $value');

    return ContactsPermissionStatus.unknown;
  }
}
