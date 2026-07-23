import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fiservtrack/auth/login_provider.dart';
import 'package:fiservtrack/home/home_provider.dart';
import 'package:fiservtrack/loan_types/loan_types_provider.dart';
import 'package:fiservtrack/public_key/public_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/theme_provider/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'themes/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _loading = true;
  bool _unsupportedAndroid = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt < 29) {
        _unsupportedAndroid = true;
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_unsupportedAndroid) {
      return const VulnerableVersionBlocker();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PublicKeyProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => LoanTypesProvider()),

        // Add future providers here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "FiservTrack",
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class VulnerableVersionBlocker extends StatelessWidget {
  const VulnerableVersionBlocker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Unsupported Version")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Your Android version is too old to run this app.\n"
              "Please update to Android 10 (Q) or later.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
