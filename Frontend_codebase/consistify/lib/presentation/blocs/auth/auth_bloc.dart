// consistify_frontend/lib/presentation/blocs/auth/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';



import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/user.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';
import 'package:consistify/domain/usecases/auth/get_user_profile.dart';
import 'package:consistify/domain/usecases/auth/login_user.dart';
import 'package:consistify/domain/usecases/auth/logout_user.dart';
import 'package:consistify/domain/usecases/auth/register_user.dart';
import 'package:consistify/domain/usecases/auth/update_user_profile.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase registerUser;
  final LoginUserUseCase loginUser;
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;
  final LogoutUserUseCase logoutUser;
  final AuthRepository authRepository; 
  final FirebaseMessaging firebaseMessaging;


  AuthBloc({
    required this.registerUser,
    required this.loginUser,
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.logoutUser,
    required this.authRepository,
    required this.firebaseMessaging,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<RegisterEvent>(_onRegisterEvent);
    on<LoginEvent>(_onLoginEvent);
    on<GetUserProfileEvent>(_onGetUserProfileEvent);
    on<UpdateUserProfileEvent>(_onUpdateUserProfileEvent);
    on<UpdateUserFCMToken>(_onUpdateUserFCMToken);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final isAuthenticated = await authRepository.isAuthenticated();
    if (isAuthenticated) {
      final userResult = await getUserProfile();
      userResult.fold(
            (failure) => emit(AuthUnauthenticated()), 
            (user) {
         
          _sendFCMTokenToBackend(user);
          emit(AuthAuthenticated(user: user));
        },
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUser(
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      username: event.username,
      notificationTime: event.notificationTime,
    );
    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (_) => emit(AuthRegistered()), 
    );
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(email: event.email, password: event.password);
    await result.fold(
          (failure) async => emit(AuthError(_mapFailureToMessage(failure))),
          (_) async {
        final userResult = await getUserProfile(); 
        userResult.fold(
              (failure) => emit(AuthError(_mapFailureToMessage(failure))),
              (user) {
          
            _sendFCMTokenToBackend(user);
            emit(AuthAuthenticated(user: user));
          },
        );
      },
    );
  }

  Future<void> _onGetUserProfileEvent(GetUserProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getUserProfile();
    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onUpdateUserProfileEvent(UpdateUserProfileEvent event, Emitter<AuthState> emit) async {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      emit(AuthLoading());
     
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String currentTimeZone = timezoneInfo.identifier; 

      final result = await updateUserProfile(
        username: event.username,
        notificationTime: event.notificationTime,
        timezone: currentTimeZone, 
        platformUsernames: event.platformUsernames,
      );
       result.fold(
            (failure) => emit(AuthError(_mapFailureToMessage(failure))),
            (_) async {
         
          add(GetUserProfileEvent());
        },
      );
    }
  }

  Future<void> _onUpdateUserFCMToken(UpdateUserFCMToken event, Emitter<AuthState> emit) async {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      
      if (currentUser.fcmTokens != null && currentUser.fcmTokens!.contains(event.fcmToken)) {
        print('FCM token ${event.fcmToken} already registered for user ${currentUser.email}.');
        return; 
      }
      print('Updating FCM token ${event.fcmToken} for user ${currentUser.email}.');
      final result = await updateUserProfile(fcmToken: event.fcmToken);
      result.fold(
            (failure) => print('Failed to update FCM token on backend: ${_mapFailureToMessage(failure)}'),
            (_) {
          print('FCM token updated successfully on backend.');
          
        },
      );
    }
  }


  Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUser();
    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case CacheFailure:
        return failure.message;
      case InvalidCredentialsFailure:
        return failure.message;
      case EmailAlreadyExistsFailure:
        return failure.message;
      case InvalidInputFailure:
        return failure.message;
      case UserNotFoundFailure:
        return failure.message;
      default:
        return 'Unexpected Error';
    }
  }

  
  void _sendFCMTokenToBackend(User user) async {
    String? fcmToken = await firebaseMessaging.getToken();
    if (fcmToken != null && (user.fcmTokens == null || !user.fcmTokens!.contains(fcmToken))) {
      add(UpdateUserFCMToken(fcmToken: fcmToken));
    }
  }
}