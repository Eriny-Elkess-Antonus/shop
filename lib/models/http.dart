class Http implements Exception {
  // 3shan el error
  final String message;
  Http(this.message);

  @override
  String toString() {
    return message;
  }
}
