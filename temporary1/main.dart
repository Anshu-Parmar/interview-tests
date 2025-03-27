import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:startopreneur/core/configs/constants/identifiers.dart';
import 'package:startopreneur/core/configs/constants/navigation_key.dart';
import 'package:startopreneur/core/configs/intents/cubits/deep_link_cubit.dart';
import 'package:startopreneur/core/configs/routes/route_generator.dart';
import 'package:startopreneur/core/configs/theme/app_theme.dart';
import 'package:startopreneur/core/configs/theme/cubit/theme_cubit.dart';
import 'package:startopreneur/core/source/shared_preferences_services.dart';
import 'package:startopreneur/firebase_options.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/user_bookmarks_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/all_news/all_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/news_tabs/tabs_cubit.dart';
import 'package:startopreneur/presentation/news/cubit/webview/webview_cubit.dart';
import 'package:startopreneur/presentation/profile/cubit/current_user_cubit.dart';
import 'package:startopreneur/service_locator.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'core/configs/constants/global_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  if (!foundation.kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<DeepLinkCubit>(create: (context) => DeepLinkCubit(),),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()..appStarted(),),
        BlocProvider<ThemesCubit>(create: (context) => ThemesCubit(),),
        BlocProvider<CurrentUserCubit>(create: (context) => CurrentUserCubit()),
        BlocProvider<UserBookmarksCubit>(create: (context) => UserBookmarksCubit()),
        BlocProvider<AllNewsCubit>(create: (context) => AllNewsCubit()..loadAllNews(),),
        BlocProvider<TabsCubit>(create: (context) => TabsCubit()..changeTab("HOME"),),
        BlocProvider<WebViewCubit>(create: (context) => WebViewCubit(),),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RateMyApp _rateMyApp = RateMyApp(
    appStoreIdentifier: Identifiers.appStoreId,
    googlePlayIdentifier: Identifiers.playStoreId,
    preferencesPrefix: "_rateMyApp",
    minDays: 0,
    minLaunches: 5,
    remindDays: 30
  );

  @override
  void initState() {
    log("Starting application", name: "CORE");
    _rateMyApp.init().then((_) => _checkIfReview(_rateMyApp));
    super.initState();
    var dispatcher = SchedulerBinding.instance.platformDispatcher;
    dispatcher.onPlatformBrightnessChanged = () async {
      final themeMode = await SharedPreferencesService.getTheme();
      if (themeMode == AppThemeMode.system) {
        var brightness = dispatcher.platformBrightness;
        context.read<ThemesCubit>().toggleTheme(AppThemeMode.system, brightnessData: brightness);
      }
    };
    targetPlatform = Theme.of(context).platform;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesCubit, ThemeData>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: context.read<ThemesCubit>().state == AppTheme.lightTheme ? ThemeMode.light : ThemeMode.dark,
          // showPerformanceOverlay: true,
          navigatorKey: AppGlobal.navigatorKey,
          debugShowCheckedModeBanner: foundation.kDebugMode ? true : false,
          title: "Start-O-Preneur",
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }

  void _checkIfReview(RateMyApp rateMyApp) async {
    ///FOR DEBUGGING rate_my_app SHARED PREFERENCES VALUES
    // for (var condition in widget.rateMyApp!.conditions) {
    //   if(condition is DebuggableCondition) {
    //     log(condition.toString(), name: 'RATE');
    //   }
    // }
    try {
      if (_rateMyApp.shouldOpenDialog) {
        Future.delayed(
          Duration(milliseconds: 3800),
          () async => await _rateMyApp
              .showRateDialog(
            context,
            title: 'Rate Start-O-Preneur',
            message: 'Please rate your experience!',
            rateButton: 'Rate',
            noButton: 'No Thanks',
            onDismissed: () => _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          )
              .then((_) {
            log("Rate and review app", name: 'REVIEW-APP');
            _rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
          }),
        );
      }
    } catch (e) {
      log("Review dialog : $e", name: 'REVIEW-APP');
    }
  }
}
