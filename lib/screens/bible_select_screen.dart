import 'package:flutter/material.dart';
import '../models/bible_book.dart';
import '../utils/routes.dart';

class BibleSelectScreen extends StatefulWidget {
  const BibleSelectScreen({super.key});

  @override
  State<BibleSelectScreen> createState() => _BibleSelectScreenState();
}

class _BibleSelectScreenState extends State<BibleSelectScreen> {
  String selectedTestament = 'old';
  BibleBook? selectedBook;
  int? selectedChapter;

  @override
  Widget build(BuildContext context) {
    final books = BibleBook.books.where((book) => book.testament == selectedTestament).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('성경 선택'),
      ),
      body: Row(
        children: [
          // 성경 구분 선택
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ListTile(
                  title: const Text('구약'),
                  selected: selectedTestament == 'old',
                  onTap: () {
                    setState(() {
                      selectedTestament = 'old';
                      selectedBook = null;
                      selectedChapter = null;
                    });
                  },
                ),
                ListTile(
                  title: const Text('신약'),
                  selected: selectedTestament == 'new',
                  onTap: () {
                    setState(() {
                      selectedTestament = 'new';
                      selectedBook = null;
                      selectedChapter = null;
                    });
                  },
                ),
              ],
            ),
          ),
          // 책 선택
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.name),
                  selected: selectedBook == book,
                  onTap: () {
                    setState(() {
                      selectedBook = book;
                      selectedChapter = null;
                    });
                  },
                );
              },
            ),
          ),
          // 장 선택
          if (selectedBook != null)
            Expanded(
              flex: 2,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: selectedBook!.chapters,
                itemBuilder: (context, index) {
                  final chapter = index + 1;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedChapter = chapter;
                      });
                      Navigator.pushNamed(
                        context,
                        Routes.write,
                        arguments: {
                          'book': selectedBook,
                          'chapter': chapter,
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedChapter == chapter
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          chapter.toString(),
                          style: TextStyle(
                            color: selectedChapter == chapter
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 