import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/domain/entities/user.dart';
import 'package:consistify/core/errors/failures.dart';

import '../../../test_helpers/usecase_mocks.dart';
import '../../../test_helpers/mocks.dart';

void main() {
  late MockRegisterUserUseCase registerUC;
  late MockLoginUserUseCase loginUC;
  late MockGetUserProfileUseCase getProfileUC;
  late MockUpdateUserProfileUseCase updateProfileUC;
  late MockLogoutUserUseCase logoutUC;
  late MockFirebaseMessaging fcm;
  late AuthBloc bloc;

  setUp(() {
    registerUC = MockRegisterUserUseCase();
    loginUC = MockLoginUserUseCase();
    getProfileUC = MockGetUserProfileUseCase();
    updateProfileUC = MockUpdateUserProfileUseCase();
    logoutUC = MockLogoutUserUseCase();
    fcm = MockFirebaseMessaging();

    bloc = AuthBloc(
      registerUser: registerUC,
      loginUser: loginUC,
      getUserProfile: getProfileUC,
      updateUserProfile: updateProfileUC,
      logoutUser: logoutUC,
      authRepository: MockAuthRepository(),
      firebaseMessaging: fcm,
    );
  });

  tearDown(() => bloc.close());

  group('Register', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthRegistered] on success',
      build: () {
        when(() => registerUC(
          email: any(named: 'email'),
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
          username: any(named: 'username'),
          notificationTime: any(named: 'notificationTime'),
        )).thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (b) => b.add(const RegisterEvent(
        email: 'a@a.com', password: '12345678', confirmPassword: '12345678', username: 'user', notificationTime: '18:00',
      )),
      expect: () => [isA<AuthLoading>(), isA<AuthRegistered>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => registerUC(
          email: any(named: 'email'),
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
          username: any(named: 'username'),
          notificationTime: any(named: 'notificationTime'),
        )).thenAnswer((_) async => Left(ServerFailure('fail')));
        return bloc;
      },
      act: (b) => b.add(const RegisterEvent(
        email: 'a@a.com', password: '12345678', confirmPassword: '12345678', username: 'user', notificationTime: '18:00',
      )),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  group('Login', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success with fetched profile',
      build: () {
        when(() => loginUC(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Right(unit));
        when(() => getProfileUC()).thenAnswer((_) async => Right(
              const User(
                id: '1', email: 'a@a.com', username: 'user', notificationTime: '18:00', timezone: 'UTC',
              ),
            ));
        when(() => fcm.getToken()).thenAnswer((_) async => 'fcm-token');
        when(() => updateProfileUC(fcmToken: any(named: 'fcmToken')))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (b) => b.add(const LoginEvent(email: 'a@a.com', password: '12345678')),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on login failure',
      build: () {
        when(() => loginUC(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => Left(InvalidCredentialsFailure('bad')));
        return bloc;
      },
      act: (b) => b.add(const LoginEvent(email: 'a@a.com', password: 'wrong')),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });
}
