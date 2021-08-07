

E? firstOrNull<E>(List<E> list) {
    if (list.isEmpty) {
      return null;
    } else {
      return list.first;
    }
}