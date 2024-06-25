// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Rectangle> rectangles = [];
  Offset start = Offset.zero;
  Offset end = Offset.zero;
  bool drawing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          start = details.localPosition;
          drawing = true;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          end = details.localPosition;
        });
      },
      onPanEnd: (details) {
        setState(() {
          rectangles.add(Rectangle(start, end));
          drawing = false;
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: DrawingPainter(rectangles, start, end, drawing),
      ),
    );
  }
}

class Rectangle {
  Offset start;
  Offset end;

  Rectangle(this.start, this.end);
}

class DrawingPainter extends CustomPainter {
  final List<Rectangle> rectangles;
  final Offset start;
  final Offset end;
  final bool drawing;

  DrawingPainter(this.rectangles, this.start, this.end, this.drawing);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var rect in rectangles) {
      canvas.drawRect(
        Rect.fromPoints(rect.start, rect.end),
        paint,
      );
    }

    if (drawing) {
      canvas.drawRect(
        Rect.fromPoints(start, end),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
