import 'package:flutter/material.dart';

class Buttonbar extends StatelessWidget {
  const Buttonbar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      items: [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Detail", icon: Icon(Icons.details)),
        BottomNavigationBarItem(
          label: "About",
          icon: Icon(Icons.account_box_outlined),
        ),
      ],
    );
  }
}
