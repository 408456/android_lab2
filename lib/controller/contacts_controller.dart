import 'dart:async';

import 'package:flutter/foundation.dart';

import '../exception/contacts_exception_handler.dart';
import '../model/contact.dart';
import '../model/contacts_state.dart';
import '../service/contacts_source.dart';
import '../utils/contacts_logger.dart';

class ContactsController extends ChangeNotifier {
  static const Duration searchDebounce = Duration(milliseconds: 300);

  final ContactsSource source;
  final ContactsExceptionHandler handler;
  final ContactsLogger logger;

  ContactsStatus _status = ContactsStatus.initial;
  ContactsPermissionStatus _permission = ContactsPermissionStatus.unknown;
  ContactsFailure? _failure;

  List<Contact> _allContacts = <Contact>[];
  List<Contact> _visibleContacts = <Contact>[];

  String _query = '';
  ContactsSortOrder _sortOrder = ContactsSortOrder.ascending;

  bool _addressBookLoaded = false;
  int _addressBookReadCount = 0;

  Timer? _searchTimer;

  ContactsController({
    required this.source,
    required this.handler,
    required this.logger,
  });

  ContactsStatus get status => _status;

  ContactsPermissionStatus get permission => _permission;

  ContactsFailure? get failure => _failure;

  List<Contact> get visibleContacts => _visibleContacts;

  int get totalCount => _allContacts.length;

  int get foundCount => _visibleContacts.length;

  String get query => _query;

  ContactsSortOrder get sortOrder => _sortOrder;

  int get addressBookReadCount => _addressBookReadCount;

  bool get addressBookLoaded => _addressBookLoaded;

  bool get isLoading => _status == ContactsStatus.loading;

  bool get isSearching => _query.trim().isNotEmpty;

  bool get addressBookIsEmpty =>
      _status == ContactsStatus.ready && _allContacts.isEmpty;

  bool get searchResultIsEmpty =>
      _status == ContactsStatus.ready &&
      _allContacts.isNotEmpty &&
      _visibleContacts.isEmpty;

  Future<void> initialize() async {
    logger.logAction('инициализация контроллера, источник: ${source.name}');

    _setStatus(ContactsStatus.loading);

    try {
      _permission = await source.checkPermission();

      logger.logState('стартовый статус разрешения: ${_permission.name}');

      if (_permission.isGranted) {
        await loadContacts();

        return;
      }

      _applyPermissionStatus();
    } catch (error, stackTrace) {
      _applyFailure(
        handler.handle(error, stackTrace, operation: 'initialize'),
      );
    }
  }

  Future<void> requestPermission() async {
    logger.logAction('пользователь запросил доступ к контактам');

    try {
      _permission = await source.requestPermission();

      logger.logState('статус разрешения после запроса: ${_permission.name}');

      if (_permission.isGranted) {
        await loadContacts(force: true);

        return;
      }

      _applyPermissionStatus();
    } catch (error, stackTrace) {
      _applyFailure(
        handler.handle(error, stackTrace, operation: 'requestPermission'),
      );
    }
  }

  Future<bool> openAppSettings() async {
    logger.logAction('пользователь открывает настройки приложения');

    try {
      return await source.openAppSettings();
    } catch (error, stackTrace) {
      _applyFailure(
        handler.handle(error, stackTrace, operation: 'openAppSettings'),
      );

      return false;
    }
  }

  Future<void> synchronizeWithSystem({required String reason}) async {
    logger.logAction('синхронизация с системой, причина: $reason');

    try {
      final actual = await source.checkPermission();

      if (actual == _permission && _statusMatchesPermission()) {
        logger.logState(
          'разрешение не изменилось (${actual.name}), '
          'повторное чтение адресной книги не требуется',
        );

        return;
      }

      logger.logState(
        'разрешение изменилось: ${_permission.name} -> ${actual.name}',
      );

      _permission = actual;

      if (_permission.isGranted) {
        await loadContacts();

        return;
      }

      _dropCache(reason: 'разрешение отозвано');
      _applyPermissionStatus();
    } catch (error, stackTrace) {
      _applyFailure(
        handler.handle(error, stackTrace, operation: 'synchronizeWithSystem'),
      );
    }
  }

  Future<void> loadContacts({bool force = false}) async {
    if (_addressBookLoaded && !force) {
      logger.logState(
        'адресная книга уже загружена (${_allContacts.length} записей), '
        'повторное чтение пропущено',
      );

      _setStatus(ContactsStatus.ready);

      return;
    }

    logger.logAction(
      'чтение адресной книги, принудительно: $force, '
      'предыдущих чтений: $_addressBookReadCount',
    );

    _setStatus(ContactsStatus.loading);

    try {
      final contacts = await source.readContacts();

      _allContacts = contacts;
      _addressBookLoaded = true;
      _addressBookReadCount++;
      _failure = null;

      logger.logData(
        'получено контактов: ${contacts.length}, '
        'всего чтений адресной книги: $_addressBookReadCount',
      );

      _rebuildVisibleContacts(reason: 'загрузка адресной книги');

      _setStatus(ContactsStatus.ready);
    } catch (error, stackTrace) {
      _applyFailure(
        handler.handle(error, stackTrace, operation: 'loadContacts'),
      );
    }
  }

  Future<void> reload() async {
    logger.logAction('ручное обновление списка контактов');

    await loadContacts(force: true);
  }

  void onSearchQueryChanged(String value) {
    logger.logAction('ввод в поле поиска: "$value"');

    _searchTimer?.cancel();

    _searchTimer = Timer(searchDebounce, () {
      applySearchQuery(value);
    });
  }

  void applySearchQuery(String value) {
    if (_query == value) {
      logger.logState('поисковый запрос не изменился, пересчёт пропущен');

      return;
    }

    _query = value;

    logger.logAction('применён поисковый запрос: "$value"');

    _rebuildVisibleContacts(reason: 'изменение поискового запроса');

    notifyListeners();
  }

  void clearSearch() {
    logger.logAction('очистка поискового запроса');

    _searchTimer?.cancel();

    applySearchQuery('');
  }

  void setSortOrder(ContactsSortOrder order) {
    if (_sortOrder == order) {
      logger.logState('порядок сортировки не изменился: ${order.name}');

      return;
    }

    _sortOrder = order;

    logger.logAction('выбран порядок сортировки: ${order.name}');

    _rebuildVisibleContacts(reason: 'изменение сортировки');

    notifyListeners();
  }

  void toggleSortOrder() {
    setSortOrder(_sortOrder.opposite);
  }

  void _rebuildVisibleContacts({required String reason}) {
    final stopwatch = Stopwatch()..start();

    final normalizedQuery = _query.trim().toLowerCase();

    final filtered = normalizedQuery.isEmpty
        ? List<Contact>.from(_allContacts)
        : _allContacts
              .where((contact) => contact.matches(normalizedQuery))
              .toList();

    filtered.sort((first, second) {
      final comparison = first.searchName.compareTo(second.searchName);

      if (_sortOrder.isAscending) {
        return comparison;
      }

      return -comparison;
    });

    _visibleContacts = List<Contact>.unmodifiable(filtered);

    stopwatch.stop();

    logger.logData(
      'пересчёт списка ($reason): запрос "$normalizedQuery", '
      'сортировка ${_sortOrder.name}, найдено ${_visibleContacts.length} '
      'из ${_allContacts.length}, обращений к адресной книге: '
      '$_addressBookReadCount',
    );

    logger.logDuration('пересчёт списка', stopwatch.elapsed);
  }

  void _dropCache({required String reason}) {
    logger.logState('сброс кеша контактов, причина: $reason');

    _allContacts = <Contact>[];
    _visibleContacts = <Contact>[];
    _addressBookLoaded = false;
  }

  void _applyPermissionStatus() {
    if (_permission.isPermanentlyDenied) {
      _setStatus(ContactsStatus.permissionPermanentlyDenied);

      return;
    }

    _setStatus(ContactsStatus.permissionDenied);
  }

  bool _statusMatchesPermission() {
    if (_permission.isGranted) {
      return _status == ContactsStatus.ready;
    }

    return _status == ContactsStatus.permissionDenied ||
        _status == ContactsStatus.permissionPermanentlyDenied;
  }

  void _applyFailure(ContactsFailure failure) {
    _failure = failure;

    if (failure.code == ContactsErrorCode.permissionPermanentlyDenied) {
      _permission = ContactsPermissionStatus.permanentlyDenied;

      _setStatus(ContactsStatus.permissionPermanentlyDenied);

      return;
    }

    if (failure.code == ContactsErrorCode.permissionDenied) {
      _permission = ContactsPermissionStatus.denied;

      _setStatus(ContactsStatus.permissionDenied);

      return;
    }

    _setStatus(ContactsStatus.error);
  }

  void _setStatus(ContactsStatus status) {
    if (_status == status) {
      notifyListeners();

      return;
    }

    logger.logState('состояние экрана: ${_status.name} -> ${status.name}');

    _status = status;

    notifyListeners();
  }

  @override
  void dispose() {
    logger.logAction('контроллер уничтожен');

    _searchTimer?.cancel();

    super.dispose();
  }
}
