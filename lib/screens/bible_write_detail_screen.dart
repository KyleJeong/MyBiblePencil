import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/bible_verse.dart';

class BibleWriteDetailScreen extends StatefulWidget {
  final List<BibleVerse> verses;
  final String bookName;
  final int chapter;

  const BibleWriteDetailScreen({
    super.key,
    required this.verses,
    required this.bookName,
    required this.chapter,
  });

  @override
  State<BibleWriteDetailScreen> createState() => _BibleWriteDetailScreenState();
}

class _BibleWriteDetailScreenState extends State<BibleWriteDetailScreen> {
  final List<List<Offset>> _strokes = [];
  final List<bool> _completedVerses = [];
  bool _isDrawing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('BibleWriteDetailScreen initialized');
    print('Total verses: ${widget.verses.length}');
    print('First verse: ${widget.verses.first.verse} - ${widget.verses.first.content}');
    
    for (var i = 0; i < widget.verses.length; i++) {
      _strokes.add([]);
      _completedVerses.add(false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkVerse(int index) {
    final currentVerse = widget.verses[index];
    final correctText = currentVerse.content.trim();

    print('Checking verse ${index + 1}: ${currentVerse.verse} - ${currentVerse.content}');

    // TODO: 실제 필사 내용을 확인하는 로직 구현
    // 현재는 임시로 모든 필사를 완료된 것으로 처리
    setState(() {
      _completedVerses[index] = true;
    });
    
    // 모든 구절이 완료되었는지 확인
    if (_completedVerses.every((completed) => completed)) {
      print('All verses completed');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('완료'),
          content: const Text('모든 구절을 필사했습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 필사 화면 닫기
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  void _clearCanvas(int index) {
    setState(() {
      _strokes[index] = [];
    });
  }

  void _onPointerDown(PointerDownEvent event, int index) {
    if (!_completedVerses[index] && event.kind == PointerDeviceKind.stylus) {
      setState(() {
        _isDrawing = true;
        _strokes[index].add(event.localPosition);
      });
    }
  }

  void _onPointerMove(PointerMoveEvent event, int index) {
    if (!_completedVerses[index] && _isDrawing && event.kind == PointerDeviceKind.stylus) {
      setState(() {
        _strokes[index].add(event.localPosition);
      });
    }
  }

  void _onPointerUp(PointerUpEvent event, int index) {
    if (!_completedVerses[index] && event.kind == PointerDeviceKind.stylus) {
      setState(() {
        _isDrawing = false;
        _strokes[index].add(Offset.infinite);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verses.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookName} ${widget.chapter}장'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // S Pen으로 그리는 중일 때는 스크롤 방지
          if (_isDrawing) {
            return true;
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '완료: ${_completedVerses.where((completed) => completed).length} / ${widget.verses.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.verses.length,
                  itemBuilder: (context, index) {
                    final verse = widget.verses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${verse.verse}절',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  verse.content,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _completedVerses[index] ? Colors.green[50] : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _completedVerses[index] ? Colors.green : Colors.grey,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Listener(
                                  onPointerDown: (event) => _onPointerDown(event, index),
                                  onPointerMove: (event) => _onPointerMove(event, index),
                                  onPointerUp: (event) => _onPointerUp(event, index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomPaint(
                                      painter: DrawingPainter(_strokes[index]),
                                      size: const Size(double.infinity, 200),
                                    ),
                                  ),
                                ),
                                if (!_completedVerses[index]) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _clearCanvas(index),
                                        child: const Text('지우기'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => _checkVerse(index),
                                        child: const Text('확인'),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      if (points[i] == Offset.infinite || points[i + 1] == Offset.infinite) {
        continue;
      }

      final xc = (points[i].dx + points[i + 1].dx) / 2;
      final yc = (points[i].dy + points[i + 1].dy) / 2;
      path.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
} 