import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:drawing_app/widgets/menu.dart' as custom_widgets;
import 'package:drawing_app/widgets/tools_menu.dart' as tools_widgets;
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
        title: Row(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: AutoSizeText(
                      
                      'QUOTE: ',
                      style: TextStyle(
                      
                        //fontSize: 18,
                        color: Color(0xFFEEF4ED),
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  WidgetSpan(
                    child: AutoSizeText(
                      'Fitzgerald Remodel',
                      style: TextStyle(
                        //fontSize: 18,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: tools_widgets.ToolsMenu(
                buttons: [
                  tools_widgets.ToolButton(
                    icon: Icons.help,
                    title: 'Help',
                    onTap: () {
                      // Handle Tool 1 tap
                    },
                  ),
                  tools_widgets.ToolButton(
                    icon: Icons.undo,
                    title: 'Undo',
                    onTap: () {
                      // Handle Tool 2 tap
                    },
                  ),
                  tools_widgets.ToolButton(
                    icon: Icons.save,
                    title: 'Save',
                    onTap: () {
                      // Handle Tool 3 tap
                    },
                  ),
                  tools_widgets.ToolButton(
                    icon: Icons.close,
                    title: 'Exit',
                    onTap: () {
                      // Handle Tool 4 tap
                    },
                  ),
                ],
              ),
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
                title: 'New Kitchen Countertop',
                onTap: () {
                  // Handle New Kitchen Countertop tap
                },
              ),
              custom_widgets.MenuButton(
                icon: Icons.crop_3_2,
                title: 'New Island',
                onTap: () {
                  // Handle New Island tap
                },
              ),
              custom_widgets.MenuButton(
                icon: Icons.download,
                title: 'Export to DXF file',
                onTap: () {
                  // Handle Export to DXF file tap
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