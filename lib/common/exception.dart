class CustomException implements Exception {
  String cause;
  int code;
  var detail;
  CustomException(this.cause, this.code, {this.detail});

  @override
  String toString() {
    return this.cause;
  }
}

class SystemException implements Exception {
  String cause;
  int code;
  SystemException(this.cause, this.code);

  @override
  String toString() {
    return this.cause;
  }
}

class AuthException implements Exception {
  String cause;
  int code;
  AuthException(this.cause, this.code);

  @override
  String toString() {
    return this.cause;
  }
}
