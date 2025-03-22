extension SentenceCase on String {
  String toSentenceCase() {
    if (isEmpty) {
      return '';
    }

    final sentences = split(RegExp(r'(?<=[.!?])\s+'));

    final sentenceCaseText = sentences
        .map((sentence) =>
            sentence.trimLeft().substring(0, 1).toUpperCase() +
            sentence.trimLeft().substring(1).toLowerCase())
        .join(' ');

    return sentenceCaseText[0].toUpperCase() + sentenceCaseText.substring(1);
  }
}
