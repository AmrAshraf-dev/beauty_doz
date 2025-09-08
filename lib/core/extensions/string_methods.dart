extension StringMethods on String {
  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.parse(this) != null;
  }

  String findBetweenLast({String start, String end}) {
    final startIndex = lastIndexOf(start);
    final endIndex = lastIndexOf(end);

    return substring(startIndex + 1, endIndex);
  }

  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
