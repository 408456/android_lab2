import 'dart:developer' as developer;

class ContactsLogger {
  static const String _rootName = 'Contacts';

  static int _sequence = 0;

  final String tag;

  const ContactsLogger(this.tag);

  ContactsLogger child(String childTag) => ContactsLogger('$tag.$childTag');

  void logAction(String action) {
    _write('ДЕЙСТВИЕ | $action', level: 500);
  }

  void logState(String state) {
    _write('СОСТОЯНИЕ | $state', level: 600);
  }

  void logData(String data) {
    _write('ДАННЫЕ | $data', level: 500);
  }

  void logPlatform(String message) {
    _write('ПЛАТФОРМА | $message', level: 700);
  }

  void logWarning(String message) {
    _write('ПРЕДУПРЕЖДЕНИЕ | $message', level: 900);
  }

  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    _write(
      'ОШИБКА | $message',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logFatal(String message, {Object? error, StackTrace? stackTrace}) {
    _write(
      'КРИТИЧЕСКАЯ ОШИБКА | $message',
      level: 1200,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logDuration(String operation, Duration duration) {
    _write(
      'ЗАМЕР | $operation занял ${duration.inMilliseconds} мс',
      level: 500,
    );
  }

  void _write(
    String message, {
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _sequence++;

    developer.log(
      '#$_sequence $message',
      name: '$_rootName.$tag',
      level: level,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }
}
