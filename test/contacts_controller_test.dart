import 'package:flutter_test/flutter_test.dart';

import '../lib/controller/contacts_controller.dart';
import '../lib/exception/contacts_exception.dart';
import '../lib/exception/contacts_exception_handler.dart';
import '../lib/model/contact.dart';
import '../lib/model/contacts_state.dart';
import '../lib/service/contacts_source.dart';
import '../lib/utils/contacts_logger.dart';

class FakeContactsSource implements ContactsSource {
  ContactsPermissionStatus permission = ContactsPermissionStatus.denied;

  bool failRead = false;
  bool emptyAddressBook = false;

  int readCount = 0;
  int requestCount = 0;

  @override
  String get name => 'FakeContactsSource';

  @override
  bool get isSimulated => true;

  @override
  Future<ContactsPermissionStatus> checkPermission() async => permission;

  @override
  Future<ContactsPermissionStatus> requestPermission() async {
    requestCount++;

    return permission;
  }

  @override
  Future<bool> openAppSettings() async => false;

  @override
  Future<List<Contact>> readContacts() async {
    readCount++;

    if (!permission.isGranted) {
      throw ContactsPermissionException(
        'нет разрешения',
        permanentlyDenied: permission.isPermanentlyDenied,
      );
    }

    if (failRead) {
      throw ContactsReadException('сбой чтения');
    }

    if (emptyAddressBook) {
      return <Contact>[];
    }

    return [
      Contact(
        id: '1',
        displayName: 'Борисов Андрей',
        phones: [ContactPhone(label: 'mobile', number: '+7 900 000-00-01')],
        emails: [],
      ),
      Contact(
        id: '2',
        displayName: 'Андреев Борис',
        phones: [],
        emails: [
          ContactEmail(label: 'personal', address: 'andreev@example.ru'),
        ],
      ),
      Contact(
        id: '3',
        displayName: 'Васильева Мария',
        phones: [ContactPhone(label: 'work', number: '+7 900 000-00-03')],
        emails: [],
      ),
    ];
  }
}

ContactsController buildController(FakeContactsSource source) {
  const logger = ContactsLogger('Test');

  return ContactsController(
    source: source,
    handler: ContactsExceptionHandler(logger),
    logger: logger,
  );
}

void main() {
  group('ContactsController', () {
    test('без разрешения показывает состояние отказа', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      await controller.initialize();

      expect(controller.status, ContactsStatus.permissionDenied);
      expect(source.readCount, 0);
    });

    test('после выдачи разрешения читает адресную книгу один раз', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();

      expect(controller.status, ContactsStatus.ready);
      expect(controller.totalCount, 3);
      expect(source.readCount, 1);
    });

    test('повторная загрузка без force не читает адресную книгу', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();
      await controller.loadContacts();
      await controller.loadContacts();

      expect(source.readCount, 1);
      expect(controller.addressBookReadCount, 1);
    });

    test('поиск фильтрует кеш без обращения к адресной книге', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();

      controller.applySearchQuery('андре');

      expect(controller.foundCount, 2);
      expect(source.readCount, 1);
    });

    test('пустой результат поиска отличается от пустой книги', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();

      controller.applySearchQuery('зззз');

      expect(controller.searchResultIsEmpty, true);
      expect(controller.addressBookIsEmpty, false);
    });

    test('пустая адресная книга даёт отдельное состояние', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;
      source.emptyAddressBook = true;

      await controller.initialize();

      expect(controller.status, ContactsStatus.ready);
      expect(controller.addressBookIsEmpty, true);
      expect(controller.searchResultIsEmpty, false);
    });

    test('сортировка работает в прямом и обратном порядке', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();

      expect(controller.visibleContacts.first.displayName, 'Андреев Борис');

      controller.setSortOrder(ContactsSortOrder.descending);

      expect(controller.visibleContacts.first.displayName, 'Васильева Мария');
      expect(source.readCount, 1);
    });

    test('сортировка сохраняется при смене поискового запроса', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();

      controller.setSortOrder(ContactsSortOrder.descending);
      controller.applySearchQuery('андре');

      expect(controller.sortOrder, ContactsSortOrder.descending);
      expect(controller.visibleContacts.first.displayName, 'Борисов Андрей');
    });

    test('ошибка чтения переводит экран в состояние ошибки', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;
      source.failRead = true;

      await controller.initialize();

      expect(controller.status, ContactsStatus.error);
      expect(controller.failure?.code, ContactsErrorCode.readFailed);
    });

    test('отзыв разрешения сбрасывает кеш контактов', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();

      expect(controller.totalCount, 3);

      source.permission = ContactsPermissionStatus.denied;

      await controller.synchronizeWithSystem(reason: 'тест');

      expect(controller.status, ContactsStatus.permissionDenied);
      expect(controller.totalCount, 0);
      expect(controller.addressBookLoaded, false);
    });

    test('возврат из настроек без изменений не читает книгу повторно', () async {
      final source = FakeContactsSource();
      final controller = buildController(source);

      source.permission = ContactsPermissionStatus.granted;

      await controller.initialize();
      await controller.synchronizeWithSystem(reason: 'возврат из настроек');

      expect(source.readCount, 1);
    });
  });
}
