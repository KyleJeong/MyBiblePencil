import 'package:flutter/material.dart';
import '../utils/routes.dart';
import 'bible_selection_screen.dart';
import 'saved_verses_screen.dart';
import 'bible_write_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyBiblePencil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BibleWriteScreen(),
                  ),
                );
              },
              child: const Text('성경 구절 쓰기'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedVersesScreen(),
                  ),
                );
              },
              child: const Text('저장된 구절 보기'),
            ),
          ],
        ),
      ),
    );
  }
} 