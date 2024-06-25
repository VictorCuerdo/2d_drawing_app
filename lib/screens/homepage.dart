import 'package:flutter/material.dart';
import '../widgets/settings_button.dart';
import '../widgets/menu.dart' as custom_widgets;
import '../canvas/canvas_logic.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2D Drawing App'),
      ),
      body: const Column(
        children: [
          custom_widgets.MenuBar(),
          Expanded(
            child: DrawingCanvas(),  
          ),
        ],
      ),
      floatingActionButton: const SettingsButton(),
    );
  }
}
