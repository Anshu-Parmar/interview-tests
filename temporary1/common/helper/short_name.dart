extension NameShortener on String {
  String toInitials() {
    return split('-')[0]
        .split(RegExp(r'\s+'))
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join('');
  }
}