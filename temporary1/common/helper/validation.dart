extension Validate on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9_%+-]+(\.[a-zA-Z0-9_%+-]+)*@[a-zA-Z0-9.]+(-[a-zA-Z0-9_%+]+)*\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^([A-Za-z]+(\s*))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');
    return passwordRegExp.hasMatch(this);
  }

}