class ContactsException implements Exception {
  final String message;
  final Object? cause;

  ContactsException(this.message, {this.cause});

  @override
  String toString() {
    if (cause == null) {
      return message;
    }

    return '$message (причина: $cause)';
  }
}

class ContactsPermissionException extends ContactsException {
  final bool permanentlyDenied;

  ContactsPermissionException(
    super.message, {
    required this.permanentlyDenied,
    super.cause,
  });
}

class ContactsReadException extends ContactsException {
  ContactsReadException(super.message, {super.cause});
}

class ContactsSourceUnavailableException extends ContactsException {
  ContactsSourceUnavailableException(super.message, {super.cause});
}
