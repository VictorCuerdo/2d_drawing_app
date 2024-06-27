// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ArcMenu extends StatefulWidget {
  final Function(BuildContext) showTextDialog;
  final VoidCallback onClearCanvas;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetZoom;

  const ArcMenu({
    super.key,
    required this.showTextDialog,
    required this.onClearCanvas,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetZoom,
  });

  @override
  _ArcMenuState createState() => _ArcMenuState();
}

class _ArcMenuState extends State<ArcMenu> {
  bool isActiveIcon = false;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.edit,
      activeIcon: Icons.close,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: isActiveIcon ? Colors.red : const Color(0xFF446539),
      onOpen: () => setState(() => isActiveIcon = true),
      onClose: () => setState(() => isActiveIcon = false),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.delete, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Clear All',
          onTap: () {
            widget.onClearCanvas();
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Pan',
          onTap: () {
            showSnackBar(context, 'Just for testing (no functionality added yet)');
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.restart_alt, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Reset Zoom',
          onTap: () {
            widget.onResetZoom();
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.zoom_out, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Zoom Out',
          onTap: () {
            widget.onZoomOut();
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.zoom_in, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Zoom In',
          onTap: () {
            widget.onZoomIn();
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, size: 30, color: Colors.transparent),
          backgroundColor: const Color(0xFF69935C),
          label: 'Round to Nearest 0.5"',
          onTap: () {
            showSnackBar(context, 'Just for testing (no functionality added yet)');
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Add Text',
          onTap: () {
            widget.showTextDialog(context);
          },
        ),
      ],
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

