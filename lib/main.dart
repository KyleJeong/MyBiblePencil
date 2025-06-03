import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bible_select_screen.dart';
import 'screens/write_screen.dart';
import 'utils/routes.dart';
import 'utils/device_utils.dart';
import 'services/bible_api_service.dart';
import 'services/language_service.dart';
import 'services/font_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        LanguageService.create(),
        FontService.create(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }

        final languageService = snapshot.data![0] as LanguageService;
        final fontService = snapshot.data![1] as FontService;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: languageService),
            ChangeNotifierProvider.value(value: fontService),
          ],
          child: MaterialApp(
            title: 'My Bible Pencil',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
            routes: {
              Routes.home: (context) => const HomeScreen(),
              Routes.bibleSelect: (context) => const BibleSelectScreen(),
              Routes.write: (context) => const WriteScreen(),
            },
          ),
        );
      },
    );
  }
}

class TabletCheckScreen extends StatelessWidget {
  const TabletCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bible Pencil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to My Bible Pencil',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
} 