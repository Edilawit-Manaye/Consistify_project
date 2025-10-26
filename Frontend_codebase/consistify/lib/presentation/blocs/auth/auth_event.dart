// consistify_frontend/lib/presentation/blocs/auth/auth_event.dart

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;
  final String notificationTime;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
    required this.notificationTime,
  });

  @override
  List<Object> get props => [email, password, confirmPassword, username, notificationTime];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GetUserProfileEvent extends AuthEvent {}

class UpdateUserProfileEvent extends AuthEvent {
  final String? username;
  final String? notificationTime;
  final Map<String, String>? platformUsernames;

  const UpdateUserProfileEvent({
    this.username,
    this.notificationTime,
    this.platformUsernames,
  });

  @override
  List<Object> get props => [username ?? '', notificationTime ?? '', platformUsernames ?? {}];
}

class UpdateUserFCMToken extends AuthEvent {
  final String fcmToken;

  const UpdateUserFCMToken({required this.fcmToken});

  @override
  List<Object> get props => [fcmToken];
}


class LogoutEvent extends AuthEvent {}