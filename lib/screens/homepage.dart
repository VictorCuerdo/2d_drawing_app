import 'package:flutter/material.dart';
import 'package:drawing_app/widgets/arc_menu.dart';
import 'package:drawing_app/widgets/menu.dart' as custom_widgets;
import 'package:drawing_app/widgets/tools_menu.dart' as tools_widgets;
import '../canvas/canvas_logic.dart';

/// The main screen of the app, where the drawing canvas is displayed.
///
/// I created this class to manage the main UI of the app, including the app bar,
/// menus, and the drawing canvas.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

/// The state class for [HomePage].
///
/// This is where I handle the interactions between the canvas and the menus,
/// as well as managing the app bar text.
class _HomePageState extends State<HomePage> {
  final GlobalKey<DrawingCanvasState> _canvasKey = GlobalKey<DrawingCanvasState>();
  String editableText = 'Fitzgerald Remodel';

  /// Clears the canvas.
  void _clearCanvas() {
    _canvasKey.currentState?.clearCanvas();
  }

  /// Zooms in on the canvas.
  void _zoomIn() {
    _canvasKey.currentState?.zoomIn();
  }

  /// Zooms out on the canvas.
  void _zoomOut() {
    _canvasKey.currentState?.zoomOut();
  }

  /// Resets the zoom on the canvas.
  void _resetZoom() {
    _canvasKey.currentState?.resetZoom();
  }

  /// Handles menu button presses.
  ///
  /// If [index] is null, it deactivates preset size drawing mode.
  /// Otherwise, it activates preset size drawing mode with the corresponding size.
  void _handleMenuButtonPress(int? index) {
    if (index == null) {
      _canvasKey.currentState?.deactivatePresetSizeDrawing();
    } else {
      double size = 0;
      switch (index) {
        case 0:
          size = 25.5;
          break;
        case 1:
          size = 30.0;
          break;
      }
      _canvasKey.currentState?.activatePresetSizeDrawing(size);
    }
  }

  /// Opens a dialog to edit the app bar text.
  void _editAppBarText(BuildContext context) {
    TextEditingController textController = TextEditingController(text: editableText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Text'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter new text"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  editableText = textController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        toolbarOpacity: 0.7,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _editAppBarText(context),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'QUOTE: ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFEEF4ED),
                      ),
                    ),
                    TextSpan(
                      text: editableText,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            tools_widgets.ToolsMenu(
              buttons: [
                tools_widgets.ToolButton(
                  icon: Icons.help,
                  title: 'Help',
                  onTap: () {
                    _showHelpDialog(context);
                  },
                ),
                tools_widgets.ToolButton(
                  icon: Icons.undo,
                  title: 'Undo',
                  onTap: () {
                    _canvasKey.currentState?.undo();
                  },
                ),
                tools_widgets.ToolButton(
                  icon: Icons.save,
                  title: 'Save',
                  onTap: () {
                    _showSaveSnackbar(context);
                  },
                ),
                tools_widgets.ToolButton(
                  icon: Icons.close,
                  title: 'Exit',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5B9851),
      ),
      body: Column(
        children: [
          const Divider(
            height: 1,
            color: Colors.white,
          ),
          custom_widgets.MenuBar(
            buttons: [
              custom_widgets.MenuButton(
                icon: Icons.crop_5_4,
                title: 'New Kitchen CounterTop',
                onTap: () {
                  _handleMenuButtonPress(0);
                },
              ),
              custom_widgets.MenuButton(
                icon: Icons.crop_3_2,
                title: 'New Island',
                onTap: () {
                  _handleMenuButtonPress(1);
                },
              ),
              custom_widgets.MenuButton(
                icon: Icons.download,
                title: 'Export to DXF file',
                onTap: () {
                  // My export functionality is missing
                },
              ),
            ],
            onButtonPressed: _handleMenuButtonPress,
          ),
          Expanded(
            child: DrawingCanvas(
              key: _canvasKey,
              onClear: _clearCanvas,
            ),
          ),
        ],
      ),
      floatingActionButton: ArcMenu(
        showTextDialog: _showTextDialog,
        onClearCanvas: _clearCanvas,
        onZoomIn: _zoomIn,
        onZoomOut: _zoomOut,
        onResetZoom: _resetZoom,
      ),
    );
  }

  /// Shows a help dialog.
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help'),
          content: const Text('This is a Demo Help Center Pop-Up.'),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a snackbar indicating the quote has been saved.
  void _showSaveSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Center(
        heightFactor: 1,
        child: Text('Quote SAVED'),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Shows a dialog to enter text for a new text label.
  void _showTextDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Text'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter label text"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _canvasKey.currentState?.addTextLabel(textController.text, const Offset(50, 50));
              },
            ),
          ],
        );
      },
    );
  }
}