import 'dart:async';

import 'package:flutter/services.dart';

import '../model/contacts_state.dart';
import '../utils/contacts_logger.dart';
import 'contacts_exception.dart';

class ContactsFailure {
  final ContactsErrorCode code;
  final String technicalMessage;
  final String operation;

  ContactsFailure({
    required this.code,
    required this.technicalMessage,
    required this.operation,
  });

  bool get isPermissionFailure =>
      code == ContactsErrorCode.permissionDenied ||
      code == ContactsErrorCode.permissionPermanentlyDenied;

  @override
  String toString() {
    return 'ContactsFailure(code: $code, operation: $operation, '
        'message: $technicalMessage)';
  }
}

class ContactsExceptionHandler {
  final ContactsLogger logger;

  ContactsExceptionHandler(this.logger);

  ContactsFailure handle(
    Object error,
    StackTrace stackTrace, {
    required String operation,
  }) {
    final failure = _classify(error, operation);

    logger.logError(
      'операция "$operation" завершилась с кодом ${failure.code.name}: '
      '${failure.technicalMessage}',
      error: error,
      stackTrace: stackTrace,
    );

    return failure;
  }

  void handleFatal(Object error, StackTrace stackTrace, {String? source}) {
    logger.logFatal(
      'необработанное исключение${source == null ? '' : ' в $source'}: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  ContactsFailure _classify(Object error, String operation) {
    if (error is ContactsPermissionException) {
      if (error.permanentlyDenied) {
        return ContactsFailure(
          code: ContactsErrorCode.permissionPermanentlyDenied,
          technicalMessage: error.message,
          operation: operation,
        );
      }

      return ContactsFailure(
        code: ContactsErrorCode.permissionDenied,
        technicalMessage: error.message,
        operation: operation,
      );
    }

    if (error is ContactsSourceUnavailableException) {
      return ContactsFailure(
        code: ContactsErrorCode.sourceUnavailable,
        technicalMessage: error.message,
        operation: operation,
      );
    }

    if (error is ContactsReadException) {
      return ContactsFailure(
        code: ContactsErrorCode.readFailed,
        technicalMessage: error.message,
        operation: operation,
      );
    }

    if (error is MissingPluginException) {
      return ContactsFailure(
        code: ContactsErrorCode.sourceUnavailable,
        technicalMessage:
            'платформенный канал не зарегистрирован: ${error.message}',
        operation: operation,
      );
    }

    if (error is PlatformException) {
      return ContactsFailure(
        code: ContactsErrorCode.readFailed,
        technicalMessage:
            'платформенная ошибка ${error.code}: ${error.message ?? ''}',
        operation: operation,
      );
    }

    if (error is TimeoutException) {
      return ContactsFailure(
        code: ContactsErrorCode.timeout,
        technicalMessage: 'превышено время ожидания адресной книги',
        operation: operation,
      );
    }

    if (error is ContactsException) {
      return ContactsFailure(
        code: ContactsErrorCode.unknown,
        technicalMessage: error.message,
        operation: operation,
      );
    }

    return ContactsFailure(
      code: ContactsErrorCode.unknown,
      technicalMessage: error.toString(),
      operation: operation,
    );
  }
}
