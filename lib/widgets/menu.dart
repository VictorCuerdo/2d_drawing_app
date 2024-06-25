import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MenuBar extends StatefulWidget {
  final List<MenuButton> buttons;

  const MenuBar({super.key, required this.buttons});

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  int? _activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: const Color(0xFF5B9851),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.buttons.asMap().entries.map((entry) {
          int index = entry.key;
          MenuButton button = entry.value;
          return Expanded(
            child: _buildMenuButton(
              context,
              button.icon,
              button.title,
              button.onTap,
              index,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuButton(
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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF446539) : const Color(0xFF77B270),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 3),
            AutoSizeText(
              title,
              style: const TextStyle(color: Colors.white),
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

class MenuButton {
  final IconData icon;
  final String title;
  final Function onTap;

  MenuButton({required this.icon, required this.title, required this.onTap});
}
