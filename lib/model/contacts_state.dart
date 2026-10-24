enum ContactsStatus {
  initial,
  loading,
  ready,
  permissionDenied,
  permissionPermanentlyDenied,
  error,
}

enum ContactsPermissionStatus { unknown, granted, denied, permanentlyDenied }

enum ContactsSortOrder { ascending, descending }

enum ContactsErrorCode {
  permissionDenied,
  permissionPermanentlyDenied,
  sourceUnavailable,
  readFailed,
  timeout,
  unknown,
}

extension ContactsPermissionStatusInfo on ContactsPermissionStatus {
  bool get isGranted => this == ContactsPermissionStatus.granted;

  bool get isPermanentlyDenied =>
      this == ContactsPermissionStatus.permanentlyDenied;

  bool get isDenied =>
      this == ContactsPermissionStatus.denied ||
      this == ContactsPermissionStatus.permanentlyDenied;
}

extension ContactsSortOrderInfo on ContactsSortOrder {
  ContactsSortOrder get opposite {
    if (this == ContactsSortOrder.ascending) {
      return ContactsSortOrder.descending;
    }

    return ContactsSortOrder.ascending;
  }

  bool get isAscending => this == ContactsSortOrder.ascending;
}
