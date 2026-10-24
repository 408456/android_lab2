import '../exception/contacts_exception.dart';
import '../model/contact.dart';
import '../model/contacts_state.dart';
import '../utils/contacts_logger.dart';
import 'contacts_source.dart';
import 'simulated_address_book.dart';

class SimulatedContactsSource implements ContactsSource {
  static const Duration permissionDialogDelay = Duration(milliseconds: 350);
  static const Duration addressBookReadDelay = Duration(milliseconds: 900);
  static const int deniesBeforePermanentDenial = 2;

  final ContactsLogger logger;

  PermissionDialogGateway? dialogGateway;

  ContactsPermissionStatus _permission = ContactsPermissionStatus.denied;
  int _denialCount = 0;

  bool _addressBookIsEmpty = false;
  bool _failNextRead = false;

  List<Contact>? _storage;

  SimulatedContactsSource({required this.logger});

  @override
  String get name => 'SimulatedContactsSource';

  @override
  bool get isSimulated => true;

  ContactsPermissionStatus get currentPermission => _permission;

  bool get addressBookIsEmpty => _addressBookIsEmpty;

  bool get failNextRead => _failNextRead;

  @override
  Future<ContactsPermissionStatus> checkPermission() async {
    logger.logPlatform(
      'проверка разрешения READ_CONTACTS, текущий статус: ${_permission.name}',
    );

    return _permission;
  }

  @override
  Future<ContactsPermissionStatus> requestPermission() async {
    logger.logPlatform('запрошено системное разрешение READ_CONTACTS');

    if (_permission.isGranted) {
      logger.logPlatform('разрешение уже выдано, диалог не показывается');

      return _permission;
    }

    if (_permission.isPermanentlyDenied) {
      logger.logPlatform(
        'системный диалог недоступен: разрешение отклонено навсегда, '
        'требуется экран настроек приложения',
      );

      return _permission;
    }

    final gateway = dialogGateway;

    if (gateway == null) {
      throw ContactsSourceUnavailableException(
        'не задан обработчик системного диалога разрешений',
      );
    }

    await Future<void>.delayed(permissionDialogDelay);

    final granted = await gateway.askContactsPermission();

    if (granted) {
      _permission = ContactsPermissionStatus.granted;
      _denialCount = 0;

      logger.logPlatform('пользователь выдал разрешение READ_CONTACTS');

      return _permission;
    }

    _denialCount++;

    if (_denialCount >= deniesBeforePermanentDenial) {
      _permission = ContactsPermissionStatus.permanentlyDenied;

      logger.logPlatform(
        'отказ №$_denialCount: система больше не будет показывать диалог',
      );

      return _permission;
    }

    _permission = ContactsPermissionStatus.denied;

    logger.logPlatform('отказ №$_denialCount: повторный запрос ещё возможен');

    return _permission;
  }

  @override
  Future<bool> openAppSettings() async {
    logger.logPlatform(
      'системный экран настроек недоступен на этой платформе, '
      'будет показан встроенный экран настроек приложения',
    );

    return false;
  }

  @override
  Future<List<Contact>> readContacts() async {
    logger.logPlatform('запрошено чтение адресной книги устройства');

    if (!_permission.isGranted) {
      throw ContactsPermissionException(
        'чтение адресной книги без разрешения READ_CONTACTS',
        permanentlyDenied: _permission.isPermanentlyDenied,
      );
    }

    final stopwatch = Stopwatch()..start();

    await Future<void>.delayed(addressBookReadDelay);

    if (_failNextRead) {
      _failNextRead = false;

      throw ContactsReadException(
        'провайдер контактов вернул ошибку ввода-вывода',
      );
    }

    if (_addressBookIsEmpty) {
      stopwatch.stop();

      logger.logPlatform('адресная книга устройства пуста');
      logger.logDuration('чтение адресной книги', stopwatch.elapsed);

      return <Contact>[];
    }

    _storage ??= SimulatedAddressBook.generateContacts();

    stopwatch.stop();

    logger.logPlatform(
      'адресная книга прочитана, записей: ${_storage!.length}',
    );
    logger.logDuration('чтение адресной книги', stopwatch.elapsed);

    return List<Contact>.unmodifiable(_storage!);
  }

  void setPermissionFromSettings(bool granted) {
    _permission = granted
        ? ContactsPermissionStatus.granted
        : ContactsPermissionStatus.denied;

    _denialCount = granted ? 0 : deniesBeforePermanentDenial;

    logger.logPlatform(
      'разрешение изменено в настройках приложения: ${_permission.name}',
    );
  }

  void simulateRevokePermission() {
    _permission = ContactsPermissionStatus.denied;
    _denialCount = 0;

    logger.logPlatform('разрешение отозвано системой');
  }

  void simulateResetPermission() {
    _permission = ContactsPermissionStatus.denied;
    _denialCount = 0;

    logger.logPlatform('состояние разрешений сброшено к первому запуску');
  }

  void simulateEmptyAddressBook(bool isEmpty) {
    _addressBookIsEmpty = isEmpty;

    logger.logPlatform('адресная книга пуста: $isEmpty');
  }

  void simulateReadFailure() {
    _failNextRead = true;

    logger.logPlatform('следующее чтение адресной книги завершится ошибкой');
  }
}
