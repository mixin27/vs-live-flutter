extension SafeList<T> on List<T>? {
  T? safeElementAt(int index) {
    // Check if the list is null or if the index is out of range
    if (this == null || index < 0 || index >= this!.length) {
      return null;
    }
    return this![index];
  }
}

extension StringX on String {
  String get initialCharacters => trim().isNotEmpty
      ? trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  String smallSentence() {
    if (length > 30) {
      return '${substring(0, 30)}...';
    } else {
      return this;
    }
  }

  String firstFewWords() {
    int startIndex = 0, indexOfSpace = 0;

    for (int i = 0; i < 6; i++) {
      indexOfSpace = indexOf(' ', startIndex);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return this;
      }
      startIndex = indexOfSpace + 1;
    }

    return '${substring(0, indexOfSpace)}...';
  }

  List<String> getExtractedUrls() {
    final RegExp exp =
        RegExp(r'(?:(?:https?):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    List<RegExpMatch> matches = exp.allMatches(this).toList();
    List<String> items = List.empty();

    for (var match in matches) {
      items.add(substring(match.start, match.end));
    }

    return items;
  }

  String getBetween(String start, String end) {
    final startIndex = indexOf(start);
    final endIndex = indexOf(end, startIndex + start.length);
    return substring(startIndex + start.length, endIndex);
  }
}
