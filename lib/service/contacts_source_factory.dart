import 'package:flutter/foundation.dart';

import '../utils/contacts_logger.dart';
import 'contacts_source.dart';
import 'native_contacts_source.dart';
import 'simulated_contacts_source.dart';

class ContactsSourceFactory {
  static ContactsSource create(ContactsLogger logger) {
    if (kIsWeb) {
      logger.logPlatform(
        'платформа web: системной адресной книги нет, '
        'используется симулятор устройства',
      );

      return SimulatedContactsSource(logger: logger.child('Simulated'));
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      logger.logPlatform(
        'платформа android: используется системная адресная книга '
        'через MethodChannel',
      );

      return NativeContactsSource(logger: logger.child('Native'));
    }

    logger.logPlatform(
      'платформа ${defaultTargetPlatform.name}: нативная реализация '
      'не подключена, используется симулятор устройства',
    );

    return SimulatedContactsSource(logger: logger.child('Simulated'));
  }
}
