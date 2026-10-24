import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/exception/contacts_exception.dart';
import '../lib/exception/contacts_exception_handler.dart';
import '../lib/model/contacts_state.dart';
import '../lib/utils/contacts_logger.dart';

void main() {
  const logger = ContactsLogger('Test');

  final handler = ContactsExceptionHandler(logger);

  ContactsFailure handle(Object error) {
    return handler.handle(
      error,
      StackTrace.current,
      operation: 'тестовая операция',
    );
  }

  group('ContactsExceptionHandler', () {
    test('обычный отказ в доступе', () {
      final failure = handle(
        ContactsPermissionException('нет доступа', permanentlyDenied: false),
      );

      expect(failure.code, ContactsErrorCode.permissionDenied);
      expect(failure.isPermissionFailure, true);
    });

    test('отказ навсегда', () {
      final failure = handle(
        ContactsPermissionException('нет доступа', permanentlyDenied: true),
      );

      expect(failure.code, ContactsErrorCode.permissionPermanentlyDenied);
    });

    test('ошибка чтения адресной книги', () {
      final failure = handle(ContactsReadException('сбой провайдера'));

      expect(failure.code, ContactsErrorCode.readFailed);
      expect(failure.technicalMessage, 'сбой провайдера');
    });

    test('недоступный источник', () {
      final failure = handle(
        ContactsSourceUnavailableException('нет реализации'),
      );

      expect(failure.code, ContactsErrorCode.sourceUnavailable);
    });

    test('отсутствующий платформенный канал', () {
      final failure = handle(MissingPluginException('нет канала'));

      expect(failure.code, ContactsErrorCode.sourceUnavailable);
    });

    test('платформенное исключение', () {
      final failure = handle(
        PlatformException(code: 'READ_FAILED', message: 'cursor is null'),
      );

      expect(failure.code, ContactsErrorCode.readFailed);
    });

    test('превышение времени ожидания', () {
      final failure = handle(TimeoutException('долго'));

      expect(failure.code, ContactsErrorCode.timeout);
    });

    test('любое другое исключение не роняет приложение', () {
      final failure = handle(StateError('что-то пошло не так'));

      expect(failure.code, ContactsErrorCode.unknown);
      expect(failure.operation, 'тестовая операция');
    });
  });
}
