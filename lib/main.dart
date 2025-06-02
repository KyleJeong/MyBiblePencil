import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bible_select_screen.dart';
import 'screens/write_screen.dart';
import 'utils/routes.dart';
import 'utils/device_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'MyBiblePencil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TabletCheckScreen(),
    );
  }
}

class TabletCheckScreen extends StatelessWidget {
  const TabletCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: DeviceUtils.isTablet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.data!) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.tablet_mac,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '이 앱은 태블릿에서만 실행할 수 있습니다.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'iPad 또는 안드로이드 태블릿에서 실행해주세요.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'MyBiblePencil',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          initialRoute: Routes.splash,
          routes: {
            Routes.splash: (context) => const SplashScreen(),
            Routes.home: (context) => const HomeScreen(),
            Routes.bibleSelect: (context) => const BibleSelectScreen(),
            Routes.write: (context) => const WriteScreen(),
            // 다른 라우트들은 나중에 추가할 예정
          },
        );
      },
    );
  }
} 