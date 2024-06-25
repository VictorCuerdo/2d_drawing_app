import 'package:flutter/material.dart';
import 'package:drawing_app/widgets/menu.dart' as custom_widgets;
import '../widgets/settings_button.dart';
import '../canvas/canvas_logic.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        toolbarOpacity: 0.7,
        title: RichText(
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
        backgroundColor: const Color(0xFF5B9851),
      ),
      body: Column(
        children: [
          custom_widgets.MenuBar(
            buttons: [
              custom_widgets.MenuButton(
                icon: Icons.crop_5_4 ,
                title: 'New Kitchen Countertop',
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
          const Expanded(
            child: DrawingCanvas(),
          ),
        ],
      ),
      floatingActionButton: const SettingsButton(),
    );
  }
}
