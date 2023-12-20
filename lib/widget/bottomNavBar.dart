import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class bottomNavBar extends StatefulWidget {
  const bottomNavBar({this.currentIndex, required this.ontap});
  final int? currentIndex;
  final Function(int) ontap;
  @override
  State<bottomNavBar> createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(0, 165, 146, 1),
      iconSize: 25,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: widget.currentIndex ?? 0,
      onTap: widget.ontap,
      selectedIconTheme: IconThemeData(color: Colors.black54),
      unselectedItemColor: Colors.white,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.tv),label: "",),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.microchip),label: ""),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user),label: "")
      ],

    );
  }
}
