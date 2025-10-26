// consistify_frontend/lib/core/errors/exceptions.dart

// Base custom exception
class CustomException implements Exception {
  final String message;
  const CustomException(this.message);

  @override
  String toString() => 'CustomException: $message';
}


class ServerException extends CustomException {
  const ServerException(String message) : super(message);
}


class CacheException extends CustomException {
  const CacheException(String message) : super(message);
}


class InvalidCredentialsException extends ServerException {
  const InvalidCredentialsException(String message) : super(message);
}

class EmailAlreadyExistsException extends ServerException {
  const EmailAlreadyExistsException(String message) : super(message);
}

class UserNotFoundException extends ServerException {
  const UserNotFoundException(String message) : super(message);
}


class InvalidInputException extends ServerException {
  const InvalidInputException(String message) : super(message);
}