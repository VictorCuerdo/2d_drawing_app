// ignore_for_file: library_private_types_in_public_api

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ToolsMenu extends StatefulWidget {
  final List<ToolButton> buttons;

  const ToolsMenu({super.key, required this.buttons});

  @override
  _ToolsMenuState createState() => _ToolsMenuState();
}

class _ToolsMenuState extends State<ToolsMenu> {
  int? _activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFF5B9851),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.buttons.asMap().entries.map((entry) {
          int index = entry.key;
          ToolButton button = entry.value;
          return _buildToolButton(
            context,
            button.icon,
            button.title,
            button.onTap,
            index,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToolButton(
    BuildContext context,
    IconData icon,
    String title,
    Function onTap,
    int index,
  ) {
    bool isActive = _activeIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeIndex = index;
        });
        onTap();
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _activeIndex = null;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.5), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.greenAccent : Colors.white, size: 24),
            const SizedBox(height: 3),
            AutoSizeText(
              title,
              style: TextStyle(
                color: isActive ? Colors.greenAccent : Colors.white,
                fontSize: 12,
              ),
              maxLines: 1,
              minFontSize: 8,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ToolButton {
  final IconData icon;
  final String title;
  final Function onTap;

  ToolButton({required this.icon, required this.title, required this.onTap});
}
