// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:drawing_app/widgets/arc_menu.dart';
import 'package:drawing_app/widgets/menu.dart' as custom_widgets;
import 'package:drawing_app/widgets/tools_menu.dart' as tools_widgets;
import '../canvas/canvas_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DrawingCanvasState> _canvasKey = GlobalKey<DrawingCanvasState>();

  void _clearCanvas() {
    _canvasKey.currentState?.clearCanvas();
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
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'QUOTE: ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFEEF4ED),
                    ),
                  ),
                  TextSpan(
                    text: 'Fitzgerald Remodel',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                
                },
              ),
              custom_widgets.MenuButton(
                icon: Icons.crop_3_2,
                title: 'New Island',
                onTap: () {
                  
                },
              ),
              custom_widgets.MenuButton(
                icon: Icons.download,
                title: 'Export to DXF file',
                onTap: () {
                  
                },
              ),
            ],
          ),
          Expanded(
            child: DrawingCanvas(
              key: _canvasKey,
              onClear: _clearCanvas,
            ),
          ),
        ],
      ),
      floatingActionButton: const ArcMenu(),
    );
  }

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

}
