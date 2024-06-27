import 'package:flutter/material.dart';

/// A widget that represents a drawing canvas.
///
/// I created this class to handle the drawing logic for the app.
/// It allows the user to draw, resize, and move rectangles and text labels.
class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key, required this.onClear});

  /// Callback function that gets called when the canvas is cleared.
  final VoidCallback onClear;

  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

/// The state class for [DrawingCanvas].
///
/// This is where I manage the state of the canvas, including drawing,
/// resizing, moving shapes, and handling undo functionality.
class DrawingCanvasState extends State<DrawingCanvas> with SingleTickerProviderStateMixin {
  List<Rectangle> rectangles = [];
  List<TextLabel> textLabels = [];
  Offset? start;
  Offset? end;
  bool drawing = false;
  bool resizing = false;
  bool dragging = false;
  TextLabel? selectedLabel;
  Rectangle? selectedRectangle;
  Offset? dragStart;
  Offset? selectedCorner;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  double? _presetSize; // Variable to store the preset size

  List<List<Rectangle>> undoStack = [];
  List<List<TextLabel>> undoStackLabels = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final curve = CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
    _animation = Tween<double>(begin: 0, end: 4).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Activates preset size drawing mode with the given [size].
  void activatePresetSizeDrawing(double size) {
    setState(() {
      _presetSize = size;
    });
  }

  /// Deactivates preset size drawing mode.
  void deactivatePresetSizeDrawing() {
    setState(() {
      _presetSize = null;
    });
  }

  /// Undoes the last action by restoring the previous state.
  void undo() {
    setState(() {
      if (undoStack.isNotEmpty && undoStackLabels.isNotEmpty) {
        rectangles = undoStack.removeLast();
        textLabels = undoStackLabels.removeLast();
      }
    });
  }

  /// Saves the current state to the undo stack.
  void _saveStateToUndoStack() {
    undoStack.add(List.from(rectangles));
    undoStackLabels.add(List.from(textLabels));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (_presetSize != null) {
          final newRect = Rectangle.fromCenter(
            center: details.localPosition,
            width: _presetSize!,
            height: _presetSize!,
          );
          if (!overlaps(newRect)) {
            setState(() {
              _saveStateToUndoStack();
              rectangles.add(newRect);
            });
          } else {
            final availablePosition = _findAvailablePosition(newRect);
            if (availablePosition != null) {
              setState(() {
                _saveStateToUndoStack();
                rectangles.add(Rectangle.fromCenter(
                  center: availablePosition,
                  width: _presetSize!,
                  height: _presetSize!,
                ));
              });
            }
          }
        } else {
          final tappedRectangleSide = _getTappedRectangleSide(details.localPosition);
          if (tappedRectangleSide != null) {
            _showEditDialog(context, tappedRectangleSide);
          }
          final tappedLabel = _getTappedLabel(details.localPosition);
          if (tappedLabel != null) {
            setState(() {
              selectedLabel = tappedLabel;
              dragStart = details.localPosition;
              dragging = true;
            });
          }
        }
      },
      onPanStart: (details) {
        if (_presetSize == null) {
          if (resizing) return;
          setState(() {
            start = details.localPosition;
            drawing = true;
          });
        }
      },
      onPanUpdate: (details) {
        if (_presetSize == null) {
          if (resizing && selectedRectangle != null) {
            setState(() {
              _saveStateToUndoStack();
              selectedRectangle!.resize(details.localPosition, selectedCorner!);
            });
          } else if (drawing) {
            setState(() {
              end = details.localPosition;
            });
          } else if (dragging && selectedRectangle != null) {
            setState(() {
              final newRect = selectedRectangle!.translate(details.localPosition - dragStart!);
              if (!overlaps(newRect, selectedRectangle!)) {
                _saveStateToUndoStack();
                selectedRectangle!.move(details.localPosition - dragStart!);
                dragStart = details.localPosition;
              }
            });
          } else if (dragging && selectedLabel != null) {
            setState(() {
              _saveStateToUndoStack();
              selectedLabel!.move(details.localPosition - dragStart!);
              dragStart = details.localPosition;
            });
          }
        }
      },
      onPanEnd: (details) {
        if (_presetSize == null) {
          if (resizing) {
            setState(() {
              resizing = false;
              selectedCorner = null;
            });
            return;
          }
          if (drawing) {
            setState(() {
              if (start != null && end != null) {
                final newRect = Rectangle(start!, end!);
                if (!overlaps(newRect)) {
                  _saveStateToUndoStack();
                  rectangles.add(newRect);
                }
              }
              drawing = false;
              start = null;
              end = null;
            });
          }
          if (dragging) {
            setState(() {
              dragging = false;
              selectedLabel = null;
              selectedRectangle = null;
            });
            _controller.reset();
          }
        }
      },
      onLongPressStart: (details) {
        if (_presetSize == null) {
          setState(() {
            for (var rect in rectangles) {
              if (rect.rect.contains(details.localPosition)) {
                selectedRectangle = rect;
                dragStart = details.localPosition;
                dragging = true;
                break;
              }
            }
            if (dragging) {
              _controller.repeat(reverse: true);
            }
          });
        }
      },
      onLongPressMoveUpdate: (details) {
        if (_presetSize == null) {
          if (dragging && selectedRectangle != null) {
            setState(() {
              final newRect = selectedRectangle!.translate(details.localPosition - dragStart!);
              if (!overlaps(newRect, selectedRectangle!)) {
                _saveStateToUndoStack();
                selectedRectangle!.move(details.localPosition - dragStart!);
                dragStart = details.localPosition;
              }
            });
          }
        }
      },
      onLongPressEnd: (details) {
        if (_presetSize == null) {
          setState(() {
            dragging = false;
            selectedRectangle = null;
          });
          _controller.reset();
        }
      },
      child: Transform(
        transform: Matrix4.identity()..translate(_offset.dx, _offset.dy)..scale(_scale),
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(
            rectangles,
            textLabels,
            start,
            end,
            drawing,
            overlaps(Rectangle(start ?? Offset.zero, end ?? Offset.zero)),
            selectedRectangle,
            _animation,
          ),
        ),
      ),
    );
  }

  /// Checks if the new rectangle [newRect] overlaps with any existing rectangles.
  ///
  /// If [ignoreRect] is provided, it will be ignored during the overlap check.
  bool overlaps(Rectangle newRect, [Rectangle? ignoreRect]) {
    for (var rect in rectangles) {
      if (rect != ignoreRect && newRect.overlaps(rect)) {
        return true;
      }
    }
    return false;
  }

  /// Finds an available position for the rectangle [rect] within the canvas.
  ///
  /// If a suitable position is found, it returns the position; otherwise, it returns null.
  Offset? _findAvailablePosition(Rectangle rect) {
    final Size canvasSize = context.size ?? Size.zero;
    for (double dx = 0; dx < canvasSize.width; dx += rect.rect.width) {
      for (double dy = 0; dy < canvasSize.height; dy += rect.rect.height) {
        final potentialRect = Rectangle.fromCenter(
          center: Offset(dx + rect.rect.width / 2, dy + rect.rect.height / 2),
          width: rect.rect.width,
          height: rect.rect.height,
        );
        if (!overlaps(potentialRect)) {
          return potentialRect.rect.center;
        }
      }
    }
    return null;
  }

  /// Adds a rectangle with the specified [width] and [height] to the canvas.
  void addRectangle(double width, double height) {
    setState(() {
      _saveStateToUndoStack();
      final newRect = Rectangle(Offset.zero, Offset(width, height));
      if (!overlaps(newRect)) {
        rectangles.add(newRect);
      }
    });
  }

  /// Adds a text label with the specified [text] at the given [position].
  void addTextLabel(String text, Offset position) {
    setState(() {
      _saveStateToUndoStack();
      Offset newPosition = position;
      for (var label in textLabels) {
        if (label.position == newPosition) {
          newPosition = Offset(newPosition.dx + 20, newPosition.dy + 20);
        }
      }
      textLabels.add(TextLabel(text, newPosition));
    });
  }

  /// Clears the canvas by removing all rectangles and text labels.
  ///
  /// Calls the [onClear] callback provided by the parent widget.
  void clearCanvas() {
    setState(() {
      _saveStateToUndoStack();
      rectangles.clear();
      textLabels.clear();
      start = null;
      end = null;
      drawing = false;
    });
    widget.onClear();
  }

  /// Zooms in by increasing the scale factor.
  void zoomIn() {
    setState(() {
      _scale *= 1.2;
    });
  }

  /// Zooms out by decreasing the scale factor.
  void zoomOut() {
    setState(() {
      _scale /= 1.2;
    });
  }

  /// Resets the zoom to the default scale factor and offset.
  void resetZoom() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
    });
  }

  /// Gets the tapped rectangle side if a tap is detected on the edges.
  RectangleSide? _getTappedRectangleSide(Offset position) {
    for (var rect in rectangles) {
      final side = rect.getTappedSide(position);
      if (side != null && !rect.rect.contains(position)) {
        return side;
      }
    }
    return null;
  }

  /// Gets the tapped text label if a tap is detected on a label.
  TextLabel? _getTappedLabel(Offset position) {
    for (var label in textLabels) {
      if ((label.position - position).distance < 30) {
        return label;
      }
    }
    return null;
  }

  /// Shows a dialog to edit the length of the tapped rectangle side.
  void _showEditDialog(BuildContext context, RectangleSide rectangleSide) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Figure'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter new length'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                final newLength = double.tryParse(controller.text);
                if (newLength != null) {
                  setState(() {
                    _saveStateToUndoStack();
                    final newRect = rectangleSide.rectangle.copyWithNewLength(rectangleSide.side, newLength);
                    if (!overlaps(newRect, rectangleSide.rectangle)) {
                      rectangleSide.rectangle.updateLength(rectangleSide.side, newLength);
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Size not allowed due to overlapping'),
                            actions: [
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// Enum representing the sides of a rectangle.
enum RectangleSideType { left, right, top, bottom }

/// Class representing a side of a rectangle.
///
/// I use this class to handle interactions with the sides of rectangles.
class RectangleSide {
  final Rectangle rectangle;
  final RectangleSideType side;

  RectangleSide(this.rectangle, this.side);
}

/// Class representing a rectangle.
///
/// I use this class to manage the properties and behavior of rectangles on the canvas.
class Rectangle {
  Offset start;
  Offset end;

  Rectangle(this.start, this.end);

  /// Gets the rectangle as a [Rect] object.
  Rect get rect => Rect.fromPoints(start, end);

  /// Checks if this rectangle overlaps with another [Rectangle].
  bool overlaps(Rectangle other) {
    return rect.overlaps(other.rect);
  }

  /// Resizes the rectangle based on the new end position and the selected corner.
  void resize(Offset newEnd, Offset corner) {
    if (corner == start) {
      start = newEnd;
    } else if (corner == end) {
      end = newEnd;
    }
  }

  /// Moves the rectangle by the given offset.
  void move(Offset offset) {
    start += offset;
    end += offset;
  }

  /// Translates the rectangle by the given offset.
  Rectangle translate(Offset offset) {
    return Rectangle(start + offset, end + offset);
  }

  /// Gets the tapped side of the rectangle if the tap is detected on the edges.
  RectangleSide? getTappedSide(Offset position) {
    const edgeThreshold = 20.0; 
    if (position.dx >= rect.left - edgeThreshold && position.dx <= rect.left + edgeThreshold) {
      return RectangleSide(this, RectangleSideType.left);
    } else if (position.dx >= rect.right - edgeThreshold && position.dx <= rect.right + edgeThreshold) {
      return RectangleSide(this, RectangleSideType.right);
    } else if (position.dy >= rect.top - edgeThreshold && position.dy <= rect.top + edgeThreshold) {
      return RectangleSide(this, RectangleSideType.top);
    } else if (position.dy >= rect.bottom - edgeThreshold && position.dy <= rect.bottom + edgeThreshold) {
      return RectangleSide(this, RectangleSideType.bottom);
    }
    return null;
  }

  /// Creates a copy of this rectangle with a new length for the specified side.
  Rectangle copyWithNewLength(RectangleSideType side, double newLength) {
    switch (side) {
      case RectangleSideType.left:
        return Rectangle(Offset(end.dx - newLength, start.dy), end);
      case RectangleSideType.right:
        return Rectangle(start, Offset(start.dx + newLength, end.dy));
      case RectangleSideType.top:
        return Rectangle(Offset(start.dx, end.dy - newLength), end);
      case RectangleSideType.bottom:
        return Rectangle(start, Offset(end.dx, start.dy + newLength));
    }
  }

  /// Updates the length of the specified side to the new length.
  void updateLength(RectangleSideType side, double newLength) {
    switch (side) {
      case RectangleSideType.left:
        start = Offset(end.dx - newLength, start.dy);
        break;
      case RectangleSideType.right:
        end = Offset(start.dx + newLength, end.dy);
        break;
      case RectangleSideType.top:
        start = Offset(start.dx, end.dy - newLength);
        break;
      case RectangleSideType.bottom:
        end = Offset(end.dx, start.dy + newLength);
        break;
    }
  }

  /// Creates a rectangle centered at the given position with the specified width and height.
  factory Rectangle.fromCenter({required Offset center, required double width, required double height}) {
    final halfWidth = width / 2;
    final halfHeight = height / 2;
    return Rectangle(
      center - Offset(halfWidth, halfHeight),
      center + Offset(halfWidth, halfHeight),
    );
  }
}

/// Class representing a text label.
///
/// I use this class to manage text labels on the canvas.
class TextLabel {
  String text;
  Offset position;

  TextLabel(this.text, this.position);

  /// Moves the text label by the given offset.
  void move(Offset offset) {
    position += offset;
  }
}

/// Custom painter for the drawing canvas.
///
/// I use this class to handle the actual drawing of rectangles and text labels on the canvas.
class DrawingPainter extends CustomPainter {
  final List<Rectangle> rectangles;
  final List<TextLabel> textLabels;
  final Offset? start;
  final Offset? end;
  final bool drawing;
  final bool overlap;
  final Rectangle? selectedRectangle;
  final Animation<double> animation;

  DrawingPainter(
    this.rectangles,
    this.textLabels,
    this.start,
    this.end,
    this.drawing,
    this.overlap,
    this.selectedRectangle,
    this.animation,
  );

  @override
  void paint(Canvas canvas, Size size) {
    const borderColor = Color(0xFFB1C8AC);
    const fillColor = Color(0xFFCFDDCD);
    const dimensionLineColor = Colors.grey;

    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final overlapPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final selectedPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dimensionPaint = Paint()
      ..color = dimensionLineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (var rect in rectangles) {
      if (rect == selectedRectangle) {
        final offset = Offset(animation.value, animation.value);
        final rectPath = Path()..addRect(rect.rect.shift(offset));
        canvas.drawPath(rectPath, selectedPaint);
      } else {
        canvas.drawRect(rect.rect, fillPaint);
        canvas.drawRect(rect.rect, paint);
      }
      _drawDimensions(canvas, rect.rect, dimensionPaint);
    }

    for (var label in textLabels) {
      _drawText(canvas, label.text, label.position);
    }

    if (drawing && start != null && end != null) {
      final rect = Rect.fromPoints(start!, end!);
      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, overlap ? overlapPaint : paint);
      _drawDimensions(canvas, rect, dimensionPaint);
    }
  }

  /// Draws the dimensions of the given [rect] on the canvas.
  void _drawDimensions(Canvas canvas, Rect rect, Paint dimensionPaint) {
    const textStyle = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
    final textSpanTop = TextSpan(
      text: rect.width.toStringAsFixed(1),
      style: textStyle,
    );
    final textSpanBottom = TextSpan(
      text: rect.width.toStringAsFixed(1),
      style: textStyle,
    );
    final textSpanLeft = TextSpan(
      text: rect.height.toStringAsFixed(1),
      style: textStyle,
    );
    final textSpanRight = TextSpan(
      text: rect.height.toStringAsFixed(1),
      style: textStyle,
    );

    final textPainterTop = TextPainter(
      text: textSpanTop,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textPainterBottom = TextPainter(
      text: textSpanBottom,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textPainterLeft = TextPainter(
      text: textSpanLeft,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textPainterRight = TextPainter(
      text: textSpanRight,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    _drawDimensionLine(canvas, rect.topLeft, rect.topRight, dimensionPaint, textPainterTop, isHorizontal: true, above: true);
    _drawDimensionLine(canvas, rect.bottomLeft, rect.bottomRight, dimensionPaint, textPainterBottom, isHorizontal: true, above: false);
    _drawDimensionLine(canvas, rect.topLeft, rect.bottomLeft, dimensionPaint, textPainterLeft, isHorizontal: false, above: true);
    _drawDimensionLine(canvas, rect.topRight, rect.bottomRight, dimensionPaint, textPainterRight, isHorizontal: false, above: false);
  }

  /// Draws a dimension line between [start] and [end] with the given [paint].
  ///
  /// Uses the [textPainter] to draw the dimension text.
  void _drawDimensionLine(Canvas canvas, Offset start, Offset end, Paint paint, TextPainter textPainter, {required bool isHorizontal, required bool above}) {
    const double lineOffset = 20.0;
    const double textOffset = 10.0;
    const double arrowSize = 5.0;

    if (isHorizontal) {
      final double yOffset = above ? -lineOffset : lineOffset;
      final Offset offset = Offset(0, yOffset);

      canvas.drawLine(start + offset, end + offset, paint);

      _drawArrow(canvas, start + offset, isHorizontal: true, paint: paint, isStart: true);
      _drawArrow(canvas, end + offset, isHorizontal: true, paint: paint, isStart: false);

      textPainter.paint(canvas, Offset((start.dx + end.dx) / 2 - textPainter.width / 2, start.dy + yOffset - textOffset));
    } else {
      final double xOffset = above ? -lineOffset : lineOffset;
      final Offset offset = Offset(xOffset, 0);

      canvas.drawLine(start + offset, end + offset, paint);

      _drawArrow(canvas, start + offset, isHorizontal: false, paint: paint, isStart: true);
      _drawArrow(canvas, end + offset, isHorizontal: false, paint: paint, isStart: false);

      textPainter.paint(canvas, Offset(start.dx + xOffset - textOffset - textPainter.width, (start.dy + end.dy) / 2 - textPainter.height / 2));
    }
  }

  /// Draws an arrow at the [position] with the given [paint].
  ///
  /// Uses [isHorizontal] and [isStart] to determine the arrow direction.
  void _drawArrow(Canvas canvas, Offset position, {required bool isHorizontal, required Paint paint, required bool isStart}) {
    const double arrowSize = 5.0;
    final Path path = Path();

    if (isHorizontal) {
      if (isStart) {
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + arrowSize, position.dy - arrowSize);
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + arrowSize, position.dy + arrowSize);
      } else {
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx - arrowSize, position.dy - arrowSize);
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx - arrowSize, position.dy + arrowSize);
      }
    } else {
      if (isStart) {
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx - arrowSize, position.dy + arrowSize);
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + arrowSize, position.dy + arrowSize);
      } else {
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx - arrowSize, position.dy - arrowSize);
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + arrowSize, position.dy - arrowSize);
      }
    }

    canvas.drawPath(path, paint);
  }

  /// Draws the given [text] at the specified [position] on the canvas.
  void _drawText(Canvas canvas, String text, Offset position) {
    const textStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final touchAreaPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    final touchRect = Rect.fromCenter(center: position, width: textPainter.width + 40, height: textPainter.height + 20);
    canvas.drawRect(touchRect, touchAreaPaint);

    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

