class Validators {
  static isEmptyOrNull(dynamic val) {
    if (val == null || val.toString().isEmpty || val == 'null') {
      return true;
    }
    return false;
  }

  static fakeValidator(dynamic val) {
    return true;
  }

  static fakeStringValidator(dynamic val) {
    return null;
  }

  static isNotEmptyOrNull(dynamic val) {
    return !isEmptyOrNull(val);
  }

  static bool validLogin(dynamic val) {
    return !isEmptyOrNull(val) || validEmail(val) || validPhone(val);
  }

  static String ifNullOrEmpty(String val) {
    return isEmptyOrNull(val) ? '' : val.trim();
  }

  static String ifNull(dynamic val, dynamic replacement) {
    return isEmptyOrNull(val) ? replacement : val;
  }

  static bool validEmail(dynamic val) {
    if (isEmptyOrNull(val) ||
        !RegExp(r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(val)) {
      return false;
    }
    return true;
  }

  static bool validPhone(dynamic val) {
    if (isEmptyOrNull(val) || !isNumeric(val) || val.length < 10) {
      return false;
    }
    return true;
  }

  static bool isEmpty(List items) {
    return items.isEmpty;
  }

  static bool isNotEmpty(List items) {
    return items.isNotEmpty;
  }

  static bool isNumeric(dynamic val) {
    if (isEmptyOrNull(val)) {
      return false;
    }
    try {
      int? parsed = int.tryParse(val.toString().replaceAll(' ', ''));
      return parsed != null ? true : false;
    } catch (e) {
      return false;
    }
  }

  static bool isDecimal(dynamic val) {
    if (isEmptyOrNull(val)) {
      return false;
    }
    try {
      double? parsed = double.tryParse(val.toString().replaceAll(' ', '').replaceAll(',', '.'));
      return parsed != null ? true : false;
    } catch (e) {
      return false;
    }
  }

  static String validPassword(dynamic val) {
    if (isEmptyOrNull(val)) {
      return "Lütfen şifrenizi giriniz.";
    }

    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%+*?&])[A-Za-z\d@$!%+*?&]{8,}$').hasMatch(val)) {
      return "En az sekiz karakter, en az bir harf, bir sayı ve bir özel karakter oluşmalıdır";
    }

    /** En az sekiz karakter, en az bir harf, bir sayı ve bir özel karakter(@$!%+*?&) oluşmalıdır */
    return '';
  }

  static bool contains(String source, String toCheck) {
    if (isEmptyOrNull(source)) {
      return false;
    }

    if (isEmptyOrNull(toCheck)) {
      return false;
    }

    if (source.toLowerCase().contains(toCheck.toLowerCase())) {
      return true;
    }

    return false;
  }

  static validateExpireDate(String val) {
    if (isEmptyOrNull(val)) {
      return "Lütfen geçerli bir son kullanma tarihi giriniz.";
    }

    if (!val.contains('/')) {
      return "Lütfen geçerli bir son kullanma tarihi giriniz.";
    }

    List<String> expireDate = val.split('/');
    int month = int.parse(expireDate[0]);
    int year = int.parse(expireDate[1]);

    if (month <= 0 || month > 12) {
      return "Lütfen geçerli bir son kullanma tarihi giriniz.";
    }

    DateTime now = DateTime.now();

    if (year < 1000) {
      return "Lütfen geçerli bir son kullanma tarihi giriniz.";
    }

    DateTime selected = DateTime(year, month, now.day, now.hour, now.minute, now.second, now.millisecond, now.microsecond);

    if (selected.isBefore(now)) {
      return "Lütfen geçerli bir son kullanma tarihi giriniz.";
    }

    return null;
  }

  static bool isPasswordValid(String val) {
    if (isEmptyOrNull(val)) {
      return false;
    }

    if (val.length != 6) {
      return false;
    }

    if ((val[0] == val[2] && val[2] == val[4]) || (val[1] == val[3] && val[3] == val[5])) {
      return false;
    }

    if (val.substring(0, 3) == val.substring(3, 6)) {
      return false;
    }

    const pattern = '0123456789-9876543210';

    int firstIndex = 0;
    int lastIndex = 3;

    while (lastIndex <= val.length) {
      var check = val.substring(firstIndex, lastIndex);

      if (pattern.contains(check)) {
        return false;
      }
      firstIndex++;
      lastIndex++;
    }

    return true;
  }
}
