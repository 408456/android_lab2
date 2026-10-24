// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Контакты 408456';

  @override
  String get appBarTitle => '408456 android_lab2';

  @override
  String get searchHint => 'Поиск по имени';

  @override
  String get searchClear => 'Очистить поиск';

  @override
  String get sortTooltip => 'Порядок сортировки';

  @override
  String get sortAscending => 'По имени: А → Я';

  @override
  String get sortDescending => 'По имени: Я → А';

  @override
  String get refreshTooltip => 'Перечитать адресную книгу';

  @override
  String statsFound(int found, int total) {
    return 'Найдено: $found из $total';
  }

  @override
  String statsReads(int count) {
    return 'Чтений адресной книги: $count';
  }

  @override
  String get sourceSimulated => 'Источник: симулятор устройства';

  @override
  String get sourceNative => 'Источник: системная адресная книга';

  @override
  String get loadingTitle => 'Чтение адресной книги';

  @override
  String get loadingMessage => 'Приложение запрашивает контакты у системы';

  @override
  String get permissionDeniedTitle => 'Нет доступа к контактам';

  @override
  String get permissionDeniedMessage =>
      'Чтобы показать список, приложению нужно разрешение на чтение контактов устройства.';

  @override
  String get permissionRequestButton => 'Запросить доступ';

  @override
  String get permissionPermanentlyDeniedTitle => 'Доступ запрещён навсегда';

  @override
  String get permissionPermanentlyDeniedMessage =>
      'Система больше не показывает запрос разрешения. Откройте настройки приложения и включите доступ к контактам вручную.';

  @override
  String get permissionOpenSettingsButton => 'Открыть настройки';

  @override
  String get emptyAddressBookTitle => 'Адресная книга пуста';

  @override
  String get emptyAddressBookMessage =>
      'Разрешение выдано, но на устройстве нет ни одного контакта.';

  @override
  String get emptySearchTitle => 'Ничего не найдено';

  @override
  String emptySearchMessage(String query) {
    return 'По запросу «$query» нет ни одного контакта.';
  }

  @override
  String get emptySearchResetButton => 'Сбросить поиск';

  @override
  String get errorTitle => 'Ошибка чтения контактов';

  @override
  String get errorRetryButton => 'Повторить';

  @override
  String get errorPermissionDenied => 'Доступ к контактам не предоставлен.';

  @override
  String get errorPermissionPermanentlyDenied =>
      'Доступ к контактам запрещён навсегда.';

  @override
  String get errorSourceUnavailable =>
      'Источник контактов недоступен на этой платформе.';

  @override
  String get errorReadFailed => 'Системный провайдер контактов вернул ошибку.';

  @override
  String get errorTimeout => 'Превышено время ожидания ответа адресной книги.';

  @override
  String get errorUnknown => 'Неизвестная ошибка.';

  @override
  String errorDetails(String details) {
    return 'Техническая информация: $details';
  }

  @override
  String get listNoPhone => 'Нет номера телефона';

  @override
  String get listHasEmailTooltip => 'У контакта есть email';

  @override
  String get detailsTitle => 'Контакт';

  @override
  String get detailsPhonesSection => 'Телефоны';

  @override
  String get detailsEmailsSection => 'Электронная почта';

  @override
  String get detailsExtraSection => 'Дополнительные поля';

  @override
  String get detailsOrganization => 'Организация';

  @override
  String get detailsNote => 'Заметка';

  @override
  String get detailsBirthday => 'День рождения';

  @override
  String get detailsIdentifier => 'Идентификатор в адресной книге';

  @override
  String get detailsNoPhones => 'Номера телефонов не указаны';

  @override
  String get detailsNoEmails => 'Адреса электронной почты не указаны';

  @override
  String get detailsNoExtra => 'Дополнительные поля недоступны';

  @override
  String get detailsPlaceholder => 'Выберите контакт из списка';

  @override
  String get labelMobile => 'мобильный';

  @override
  String get labelWork => 'рабочий';

  @override
  String get labelHome => 'домашний';

  @override
  String get labelPersonal => 'личный';

  @override
  String get labelOther => 'другой';

  @override
  String get systemDialogTitle =>
      'Разрешить приложению «Контакты 408456» доступ к вашим контактам?';

  @override
  String get systemDialogMessage =>
      'Приложение прочитает имена, номера телефонов и адреса электронной почты из адресной книги устройства.';

  @override
  String get systemDialogAllow => 'Разрешить';

  @override
  String get systemDialogDeny => 'Запретить';

  @override
  String get settingsTitle => 'Настройки приложения';

  @override
  String get settingsApplicationName => 'Контакты 408456';

  @override
  String get settingsPackageName => 'ru.goltsman.android_lab2';

  @override
  String get settingsPermissionsSection => 'Разрешения';

  @override
  String get settingsContactsPermission => 'Контакты';

  @override
  String get settingsAllowed => 'Разрешено';

  @override
  String get settingsDenied => 'Запрещено';

  @override
  String get settingsHint =>
      'После возврата на экран приложение само проверит разрешение и обновит данные при необходимости.';

  @override
  String get settingsBack => 'Назад в приложение';

  @override
  String get simulatorTitle => 'Эмулятор устройства';

  @override
  String get simulatorResetPermission =>
      'Сбросить разрешение к первому запуску';

  @override
  String get simulatorRevokePermission => 'Отозвать выданное разрешение';

  @override
  String get simulatorEmptyAddressBook => 'Сделать адресную книгу пустой';

  @override
  String get simulatorFillAddressBook => 'Вернуть контакты в адресную книгу';

  @override
  String get simulatorReadFailure =>
      'Вызвать ошибку чтения при следующем запросе';
}
