List<int> extractBookIds(List<dynamic> books) {
  List<int> ids = books
      .map((book) => (book as Map<String, dynamic>)['id'] as int)
      .toList();
  return ids;
}

