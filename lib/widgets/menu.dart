// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// A widget that represents a menu bar with buttons.
///
/// I created this class to provide a customizable menu bar that can hold multiple buttons.
class MenuBar extends StatefulWidget {
  final List<MenuButton> buttons;
  final Function(int?) onButtonPressed;

  const MenuBar({super.key, required this.buttons, required this.onButtonPressed});

  @override
  _MenuBarState createState() => _MenuBarState();
}

/// The state class for [MenuBar].
///
/// This is where I manage the state of the menu bar, including the active button.
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
              () {
                setState(() {
                  if (_activeIndex == index) {
                    _activeIndex = null;
                  } else {
                    _activeIndex = index;
                  }
                });
                widget.onButtonPressed(_activeIndex);
              },
              index,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds a menu button with the given properties.
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

/// A class representing a button in the menu bar.
///
/// I created this class to encapsulate the properties and behavior of each menu button.
class MenuButton {
  final IconData icon;
  final String title;
  final Function onTap;
  final double? size;

  MenuButton({required this.icon, required this.title, required this.onTap, this.size});
}
