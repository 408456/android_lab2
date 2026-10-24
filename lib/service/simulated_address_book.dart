import 'dart:math';

import '../model/contact.dart';

class SimulatedAddressBook {
  static const int contactsCount = 520;

  static const String ownerEmail = 'goltsman.gleb@gmail.com';

  static const List<String> _maleNames = [
    'Александр',
    'Дмитрий',
    'Максим',
    'Сергей',
    'Андрей',
    'Алексей',
    'Артём',
    'Илья',
    'Кирилл',
    'Михаил',
    'Никита',
    'Матвей',
    'Роман',
    'Егор',
    'Арсений',
    'Иван',
    'Денис',
    'Евгений',
    'Данил',
    'Тимур',
  ];

  static const List<String> _femaleNames = [
    'Анастасия',
    'Анна',
    'Мария',
    'Елена',
    'Дарья',
    'Алина',
    'Ирина',
    'Екатерина',
    'Арина',
    'Полина',
    'Ольга',
    'Юлия',
    'Татьяна',
    'Наталья',
    'Виктория',
    'Елизавета',
    'Ксения',
    'Милана',
    'Вероника',
    'София',
  ];

  static const List<String> _maleSurnames = [
    'Иванов',
    'Смирнов',
    'Кузнецов',
    'Попов',
    'Васильев',
    'Петров',
    'Соколов',
    'Михайлов',
    'Новиков',
    'Фёдоров',
    'Морозов',
    'Волков',
    'Алексеев',
    'Лебедев',
    'Семёнов',
    'Егоров',
    'Павлов',
    'Козлов',
    'Степанов',
    'Николаев',
    'Орлов',
    'Андреев',
    'Макаров',
    'Никитин',
    'Захаров',
    'Зайцев',
    'Соловьёв',
    'Борисов',
    'Яковлев',
    'Григорьев',
  ];

  static const List<String> _patronymics = [
    'Александрович',
    'Дмитриевич',
    'Сергеевич',
    'Андреевич',
    'Алексеевич',
    'Иванович',
    'Михайлович',
    'Николаевич',
  ];

  static const List<String> _organizations = [
    'ИжГТУ, кафедра ПОВТ',
    'Яндекс',
    'Сбербанк',
    'Ижевский радиозавод',
    'Т-Банк',
    'VK',
    'Ростелеком',
    'Доставка еды',
  ];

  static const List<String> _notes = [
    'одногруппник',
    'сосед по общежитию',
    'работа, проектная команда',
    'тренер по плаванию',
    'репетитор по английскому',
    'не звонить после 22:00',
  ];

  static const Map<String, String> _translit = {
    'а': 'a',
    'б': 'b',
    'в': 'v',
    'г': 'g',
    'д': 'd',
    'е': 'e',
    'ё': 'e',
    'ж': 'zh',
    'з': 'z',
    'и': 'i',
    'й': 'y',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'ф': 'f',
    'х': 'h',
    'ц': 'c',
    'ч': 'ch',
    'ш': 'sh',
    'щ': 'sch',
    'ъ': '',
    'ы': 'y',
    'ь': '',
    'э': 'e',
    'ю': 'yu',
    'я': 'ya',
  };

  static List<Map<Object?, Object?>> generate() {
    final random = Random(408456);
    final result = <Map<Object?, Object?>>[];

    result.add(_owner());

    for (int index = 1; index < contactsCount; index++) {
      result.add(_generateOne(index, random));
    }

    return result;
  }

  static Map<Object?, Object?> _owner() {
    return {
      'id': 'contact-0',
      'displayName': 'Гольцман Глеб Дмитриевич',
      'phones': [
        {'label': 'mobile', 'number': '+7 (912) 408-45-60'},
      ],
      'emails': [
        {'label': 'personal', 'address': ownerEmail},
      ],
      'organization': 'ИжГТУ, группа 408456',
      'note': 'владелец устройства',
      'birthday': '2004-05-17',
    };
  }

  static Map<Object?, Object?> _generateOne(int index, Random random) {
    final isMale = random.nextBool();

    final name = isMale
        ? _maleNames[random.nextInt(_maleNames.length)]
        : _femaleNames[random.nextInt(_femaleNames.length)];

    final baseSurname = _maleSurnames[random.nextInt(_maleSurnames.length)];
    final surname = isMale ? baseSurname : '${baseSurname}а';

    final patronymic = _patronymics[random.nextInt(_patronymics.length)];

    final displayName = isMale && index % 6 == 0
        ? '$surname $name $patronymic'
        : '$surname $name';

    final phones = <Map<String, String>>[];
    final emails = <Map<String, String>>[];

    final hasPhone = index % 11 != 0;
    final hasSecondPhone = index % 9 == 0;
    final hasEmail = index % 3 != 0;

    if (hasPhone) {
      phones.add({'label': 'mobile', 'number': _phone(random)});
    }

    if (hasPhone && hasSecondPhone) {
      phones.add({'label': 'work', 'number': _phone(random)});
    }

    if (index % 23 == 0) {
      phones.add({'label': 'home', 'number': _phone(random)});
    }

    if (hasEmail) {
      emails.add({
        'label': 'personal',
        'address': '${_latin(surname)}.${_latin(name)}@example.ru',
      });
    }

    if (hasEmail && index % 13 == 0) {
      emails.add({
        'label': 'work',
        'address': '${_latin(surname)}@company.ru',
      });
    }

    return {
      'id': 'contact-$index',
      'displayName': displayName,
      'phones': phones,
      'emails': emails,
      'organization': index % 4 == 0
          ? _organizations[random.nextInt(_organizations.length)]
          : null,
      'note': index % 7 == 0 ? _notes[random.nextInt(_notes.length)] : null,
      'birthday': index % 5 == 0
          ? '19${70 + random.nextInt(30)}-'
                '${(1 + random.nextInt(12)).toString().padLeft(2, '0')}-'
                '${(1 + random.nextInt(28)).toString().padLeft(2, '0')}'
          : null,
    };
  }

  static String _phone(Random random) {
    final code = 900 + random.nextInt(99);
    final first = random.nextInt(1000).toString().padLeft(3, '0');
    final second = random.nextInt(100).toString().padLeft(2, '0');
    final third = random.nextInt(100).toString().padLeft(2, '0');

    return '+7 ($code) $first-$second-$third';
  }

  static String _latin(String source) {
    final buffer = StringBuffer();

    for (final symbol in source.toLowerCase().split('')) {
      buffer.write(_translit[symbol] ?? '');
    }

    return buffer.toString();
  }

  static List<Contact> generateContacts() {
    return generate().map(Contact.fromMap).toList();
  }
}
