import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[200],
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMenuButton(context, 'New Kitchen Countertop', () {
         
          }),
          _buildMenuButton(context, 'New Island', () {
            
          }),
          _buildMenuButton(context, 'Export to DXF file', () {
          
          }),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
