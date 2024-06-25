// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ArcMenu extends StatefulWidget {
  const ArcMenu({super.key});

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
            showSnackBar(context, 'Clearing All');
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
          child: const Icon(Icons.restart_alt, size: 30, color: Colors.transparent),
          backgroundColor: const Color(0xFF69935C),
          label: 'Reset Zoom',
          onTap: () {
            showSnackBar(context, 'Just for testing (no functionality added yet)');
          },
        ),
        

 SpeedDialChild(
          child: const Icon(Icons.zoom_out, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Zoom Out',
          onTap: () {
            showSnackBar(context, 'Zooming Out');
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.zoom_in, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Zoom In',
          onTap: () {
            showSnackBar(context, 'Zooming In');
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


        //FIRST ITEM FROM THE ARC MENU STARTING FROM TOP
        SpeedDialChild(
          child: const Icon(Icons.add, size: 30, color: Colors.white),
          backgroundColor: const Color(0xFF69935C),
          label: 'Add Text',
          onTap: () {
            showSnackBar(context, 'Adding text');
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
