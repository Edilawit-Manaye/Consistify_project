import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'package:consistify/core/config/firebase_options.dart'; 
import 'package:consistify/core/theme/app_theme.dart';
import 'package:consistify/injection_container.dart' as di;
import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/presentation/blocs/consistency/consistency_bloc.dart';
import 'package:consistify/presentation/pages/auth/login_page.dart';
import 'package:consistify/presentation/pages/auth/register_page.dart';
import 'package:consistify/presentation/pages/dashboard/dashboard_page.dart';
import 'package:consistify/presentation/pages/onboarding/welcome_page.dart';
import 'package:consistify/presentation/widgets/loading_indicator.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

bool get _isMobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);


@pragma('vm:entry-point') 
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
  
  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'consistify_channel_id',
          'Consistify Notifications',
          channelDescription: 'Notifications for Consistify app activities',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          icon: '@mipmap/ic_launcher', 
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  
  if (_isMobile) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  
  await di.init();

  
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); 
  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  
  if (_isMobile) {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    if (_isMobile) {
      _configureFirebaseMessaging();
    }
  }

  void _configureFirebaseMessaging() {
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'consistify_channel_id',
              'Consistify Notifications',
              channelDescription: 'Notifications for Consistify app activities',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });

    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state with message: ${message.data}');
        
      }
    });

    
    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        print("FCM Token: $token");
       
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AppStarted()),

        ),
        BlocProvider<ConsistencyBloc>(
          create: (_) => di.sl<ConsistencyBloc>(), 
        ),
      ],
      child: MaterialApp(
        title: 'Consistify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return const LoadingIndicator(); 
            } else if (state is AuthAuthenticated) {
             
              context.read<ConsistencyBloc>().add(LoadConsistencyData());
              return const DashboardPage();
            } else if (state is AuthUnauthenticated) {
              return const WelcomePage();
            } else if (state is AuthRegistered) {
             
              return const LoginPage();
            }
            return const WelcomePage(); 
          },
        ),
        routes: {
          '/welcome': (context) => const WelcomePage(),
          '/register': (context) => const RegisterPage(),
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
}