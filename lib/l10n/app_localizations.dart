import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Контакты 408456'**
  String get appTitle;

  /// No description provided for @appBarTitle.
  ///
  /// In ru, this message translates to:
  /// **'408456 android_lab2'**
  String get appBarTitle;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по имени'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get searchClear;

  /// No description provided for @sortTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Порядок сортировки'**
  String get sortTooltip;

  /// No description provided for @sortAscending.
  ///
  /// In ru, this message translates to:
  /// **'По имени: А → Я'**
  String get sortAscending;

  /// No description provided for @sortDescending.
  ///
  /// In ru, this message translates to:
  /// **'По имени: Я → А'**
  String get sortDescending;

  /// No description provided for @refreshTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Перечитать адресную книгу'**
  String get refreshTooltip;

  /// No description provided for @statsFound.
  ///
  /// In ru, this message translates to:
  /// **'Найдено: {found} из {total}'**
  String statsFound(int found, int total);

  /// No description provided for @statsReads.
  ///
  /// In ru, this message translates to:
  /// **'Чтений адресной книги: {count}'**
  String statsReads(int count);

  /// No description provided for @sourceSimulated.
  ///
  /// In ru, this message translates to:
  /// **'Источник: симулятор устройства'**
  String get sourceSimulated;

  /// No description provided for @sourceNative.
  ///
  /// In ru, this message translates to:
  /// **'Источник: системная адресная книга'**
  String get sourceNative;

  /// No description provided for @loadingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Чтение адресной книги'**
  String get loadingTitle;

  /// No description provided for @loadingMessage.
  ///
  /// In ru, this message translates to:
  /// **'Приложение запрашивает контакты у системы'**
  String get loadingMessage;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа к контактам'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionDeniedMessage.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы показать список, приложению нужно разрешение на чтение контактов устройства.'**
  String get permissionDeniedMessage;

  /// No description provided for @permissionRequestButton.
  ///
  /// In ru, this message translates to:
  /// **'Запросить доступ'**
  String get permissionRequestButton;

  /// No description provided for @permissionPermanentlyDeniedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Доступ запрещён навсегда'**
  String get permissionPermanentlyDeniedTitle;

  /// No description provided for @permissionPermanentlyDeniedMessage.
  ///
  /// In ru, this message translates to:
  /// **'Система больше не показывает запрос разрешения. Откройте настройки приложения и включите доступ к контактам вручную.'**
  String get permissionPermanentlyDeniedMessage;

  /// No description provided for @permissionOpenSettingsButton.
  ///
  /// In ru, this message translates to:
  /// **'Открыть настройки'**
  String get permissionOpenSettingsButton;

  /// No description provided for @emptyAddressBookTitle.
  ///
  /// In ru, this message translates to:
  /// **'Адресная книга пуста'**
  String get emptyAddressBookTitle;

  /// No description provided for @emptyAddressBookMessage.
  ///
  /// In ru, this message translates to:
  /// **'Разрешение выдано, но на устройстве нет ни одного контакта.'**
  String get emptyAddressBookMessage;

  /// No description provided for @emptySearchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get emptySearchTitle;

  /// No description provided for @emptySearchMessage.
  ///
  /// In ru, this message translates to:
  /// **'По запросу «{query}» нет ни одного контакта.'**
  String emptySearchMessage(String query);

  /// No description provided for @emptySearchResetButton.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить поиск'**
  String get emptySearchResetButton;

  /// No description provided for @errorTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка чтения контактов'**
  String get errorTitle;

  /// No description provided for @errorRetryButton.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get errorRetryButton;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к контактам не предоставлен.'**
  String get errorPermissionDenied;

  /// No description provided for @errorPermissionPermanentlyDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к контактам запрещён навсегда.'**
  String get errorPermissionPermanentlyDenied;

  /// No description provided for @errorSourceUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Источник контактов недоступен на этой платформе.'**
  String get errorSourceUnavailable;

  /// No description provided for @errorReadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Системный провайдер контактов вернул ошибку.'**
  String get errorReadFailed;

  /// No description provided for @errorTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Превышено время ожидания ответа адресной книги.'**
  String get errorTimeout;

  /// No description provided for @errorUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестная ошибка.'**
  String get errorUnknown;

  /// No description provided for @errorDetails.
  ///
  /// In ru, this message translates to:
  /// **'Техническая информация: {details}'**
  String errorDetails(String details);

  /// No description provided for @listNoPhone.
  ///
  /// In ru, this message translates to:
  /// **'Нет номера телефона'**
  String get listNoPhone;

  /// No description provided for @listHasEmailTooltip.
  ///
  /// In ru, this message translates to:
  /// **'У контакта есть email'**
  String get listHasEmailTooltip;

  /// No description provided for @detailsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Контакт'**
  String get detailsTitle;

  /// No description provided for @detailsPhonesSection.
  ///
  /// In ru, this message translates to:
  /// **'Телефоны'**
  String get detailsPhonesSection;

  /// No description provided for @detailsEmailsSection.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get detailsEmailsSection;

  /// No description provided for @detailsExtraSection.
  ///
  /// In ru, this message translates to:
  /// **'Дополнительные поля'**
  String get detailsExtraSection;

  /// No description provided for @detailsOrganization.
  ///
  /// In ru, this message translates to:
  /// **'Организация'**
  String get detailsOrganization;

  /// No description provided for @detailsNote.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get detailsNote;

  /// No description provided for @detailsBirthday.
  ///
  /// In ru, this message translates to:
  /// **'День рождения'**
  String get detailsBirthday;

  /// No description provided for @detailsIdentifier.
  ///
  /// In ru, this message translates to:
  /// **'Идентификатор в адресной книге'**
  String get detailsIdentifier;

  /// No description provided for @detailsNoPhones.
  ///
  /// In ru, this message translates to:
  /// **'Номера телефонов не указаны'**
  String get detailsNoPhones;

  /// No description provided for @detailsNoEmails.
  ///
  /// In ru, this message translates to:
  /// **'Адреса электронной почты не указаны'**
  String get detailsNoEmails;

  /// No description provided for @detailsNoExtra.
  ///
  /// In ru, this message translates to:
  /// **'Дополнительные поля недоступны'**
  String get detailsNoExtra;

  /// No description provided for @detailsPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Выберите контакт из списка'**
  String get detailsPlaceholder;

  /// No description provided for @labelMobile.
  ///
  /// In ru, this message translates to:
  /// **'мобильный'**
  String get labelMobile;

  /// No description provided for @labelWork.
  ///
  /// In ru, this message translates to:
  /// **'рабочий'**
  String get labelWork;

  /// No description provided for @labelHome.
  ///
  /// In ru, this message translates to:
  /// **'домашний'**
  String get labelHome;

  /// No description provided for @labelPersonal.
  ///
  /// In ru, this message translates to:
  /// **'личный'**
  String get labelPersonal;

  /// No description provided for @labelOther.
  ///
  /// In ru, this message translates to:
  /// **'другой'**
  String get labelOther;

  /// No description provided for @systemDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить приложению «Контакты 408456» доступ к вашим контактам?'**
  String get systemDialogTitle;

  /// No description provided for @systemDialogMessage.
  ///
  /// In ru, this message translates to:
  /// **'Приложение прочитает имена, номера телефонов и адреса электронной почты из адресной книги устройства.'**
  String get systemDialogMessage;

  /// No description provided for @systemDialogAllow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить'**
  String get systemDialogAllow;

  /// No description provided for @systemDialogDeny.
  ///
  /// In ru, this message translates to:
  /// **'Запретить'**
  String get systemDialogDeny;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки приложения'**
  String get settingsTitle;

  /// No description provided for @settingsApplicationName.
  ///
  /// In ru, this message translates to:
  /// **'Контакты 408456'**
  String get settingsApplicationName;

  /// No description provided for @settingsPackageName.
  ///
  /// In ru, this message translates to:
  /// **'ru.goltsman.android_lab2'**
  String get settingsPackageName;

  /// No description provided for @settingsPermissionsSection.
  ///
  /// In ru, this message translates to:
  /// **'Разрешения'**
  String get settingsPermissionsSection;

  /// No description provided for @settingsContactsPermission.
  ///
  /// In ru, this message translates to:
  /// **'Контакты'**
  String get settingsContactsPermission;

  /// No description provided for @settingsAllowed.
  ///
  /// In ru, this message translates to:
  /// **'Разрешено'**
  String get settingsAllowed;

  /// No description provided for @settingsDenied.
  ///
  /// In ru, this message translates to:
  /// **'Запрещено'**
  String get settingsDenied;

  /// No description provided for @settingsHint.
  ///
  /// In ru, this message translates to:
  /// **'После возврата на экран приложение само проверит разрешение и обновит данные при необходимости.'**
  String get settingsHint;

  /// No description provided for @settingsBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад в приложение'**
  String get settingsBack;

  /// No description provided for @simulatorTitle.
  ///
  /// In ru, this message translates to:
  /// **'Эмулятор устройства'**
  String get simulatorTitle;

  /// No description provided for @simulatorResetPermission.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить разрешение к первому запуску'**
  String get simulatorResetPermission;

  /// No description provided for @simulatorRevokePermission.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать выданное разрешение'**
  String get simulatorRevokePermission;

  /// No description provided for @simulatorEmptyAddressBook.
  ///
  /// In ru, this message translates to:
  /// **'Сделать адресную книгу пустой'**
  String get simulatorEmptyAddressBook;

  /// No description provided for @simulatorFillAddressBook.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть контакты в адресную книгу'**
  String get simulatorFillAddressBook;

  /// No description provided for @simulatorReadFailure.
  ///
  /// In ru, this message translates to:
  /// **'Вызвать ошибку чтения при следующем запросе'**
  String get simulatorReadFailure;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
