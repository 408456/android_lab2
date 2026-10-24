class ContactPhone {
  final String label;
  final String number;

  ContactPhone({required this.label, required this.number});

  factory ContactPhone.fromMap(Map<Object?, Object?> map) {
    return ContactPhone(
      label: (map['label'] as String?) ?? '',
      number: (map['number'] as String?) ?? '',
    );
  }

  @override
  String toString() => '$label: $number';
}

class ContactEmail {
  final String label;
  final String address;

  ContactEmail({required this.label, required this.address});

  factory ContactEmail.fromMap(Map<Object?, Object?> map) {
    return ContactEmail(
      label: (map['label'] as String?) ?? '',
      address: (map['address'] as String?) ?? '',
    );
  }

  @override
  String toString() => '$label: $address';
}

class Contact {
  final String id;
  final String displayName;
  final List<ContactPhone> phones;
  final List<ContactEmail> emails;
  final String? organization;
  final String? note;
  final String? birthday;

  final String searchName;

  Contact({
    required this.id,
    required this.displayName,
    required this.phones,
    required this.emails,
    this.organization,
    this.note,
    this.birthday,
  }) : searchName = displayName.toLowerCase();

  factory Contact.fromMap(Map<Object?, Object?> map) {
    final phones = (map['phones'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<Object?, Object?>>()
        .map(ContactPhone.fromMap)
        .where((phone) => phone.number.isNotEmpty)
        .toList();

    final emails = (map['emails'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<Object?, Object?>>()
        .map(ContactEmail.fromMap)
        .where((email) => email.address.isNotEmpty)
        .toList();

    return Contact(
      id: (map['id'] as String?) ?? '',
      displayName: (map['displayName'] as String?) ?? '',
      phones: phones,
      emails: emails,
      organization: map['organization'] as String?,
      note: map['note'] as String?,
      birthday: map['birthday'] as String?,
    );
  }

  bool get hasPhone => phones.isNotEmpty;

  bool get hasEmail => emails.isNotEmpty;

  ContactPhone? get primaryPhone {
    if (phones.isEmpty) {
      return null;
    }

    return phones.first;
  }

  String get initials {
    final parts = displayName
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return parts[0].substring(0, 1).toUpperCase() +
        parts[1].substring(0, 1).toUpperCase();
  }

  bool matches(String normalizedQuery) {
    if (normalizedQuery.isEmpty) {
      return true;
    }

    return searchName.contains(normalizedQuery);
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $displayName, phones: ${phones.length}, '
        'emails: ${emails.length})';
  }
}
