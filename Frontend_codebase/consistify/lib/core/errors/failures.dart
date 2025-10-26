// consistify_frontend/lib/core/errors/failures.dart

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}


class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(String message) : super(message);
}

class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure(String message) : super(message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure(String message) : super(message);
}


class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);
}