import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:task_management/core/services/notification_service.dart';
import 'package:task_management/core/theme/azkar_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_management/core/cache/app_cache.dart';
import 'package:task_management/core/theme/app_text_theme.dart';
import 'package:task_management/src/api/database_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/logic/cubit/theme_cubit.dart';
import 'src/view/pages/main_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await di.configureDependencies();

    // Initialize Database
    final databaseController = di.sl<DatabaseController>();
    await databaseController.initializeDatabase();

    // Initialize AppCache
    await AppCache.initializeCache();

    // Initialize NotificationService
    NotificationService.initialize();
    NotificationService.ensurePermission();



    AwesomeNotifications().setListeners(
      onActionReceivedMethod: listenToActions,
      onNotificationCreatedMethod: (receivedNotification) async {
        print('Notification Created on ${DateTime.now()}');
      },
      onNotificationDisplayedMethod: (receivedNotification) async {},
      onDismissActionReceivedMethod: (receivedAction) async {
        print('Notification Dismissed on ${DateTime.now()}');
      },
    );
    // Run the app
    runApp(const MyApp());
  } catch (e) {
    // Handle initialization errors
    runApp(
      MaterialApp(
        theme: AzkarTheme.lightTheme,
        darkTheme: AzkarTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: Scaffold(
          backgroundColor: AzkarTheme.darkBackground,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AzkarTheme.errorColor,
                    size: 72,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Initialization Error',
                    style: AppTextTheme.lightTextTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to initialize the app. Please try again later.\n\nError: $e',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Try to restart the app
                      main();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AzkarTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Global navigator key for accessing context anywhere in the app
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc: di.sl<ThemeCubit>(),
      builder: (context, themeMode) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'وقتي أمانة',
          theme: AzkarTheme.lightTheme,
          darkTheme: AzkarTheme.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SY'), // Arabic Syria
            Locale('ar', ''), // Arabic
          ],
          locale: const Locale('ar', 'SY'),
          home: const _AppLifecycleWrapper(child: MainPage()),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0), // Prevent text scaling
                ),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

class _AppLifecycleWrapper extends StatefulWidget {
  final Widget child;
  const _AppLifecycleWrapper({required this.child});

  @override
  State<_AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<_AppLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => widget.child;
}
