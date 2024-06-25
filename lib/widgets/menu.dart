import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MenuBar extends StatelessWidget {
  final List<MenuButton> buttons;

  const MenuBar({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, 
      color: const Color(0xFF5B9851),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return Expanded(
            child: _buildMenuButton(context, button.icon, button.title, button.onTap),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, IconData icon, String title, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF77B270),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 5),
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
