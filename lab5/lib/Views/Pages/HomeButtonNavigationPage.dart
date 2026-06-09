import 'package:exam/Views/Widgets/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:exam/Views/Widgets/ButtonBar.dart';
import 'package:exam/Views/Widgets/Product_Widget.dart';

class HomebuttonnavigationPage extends StatefulWidget {
  const HomebuttonnavigationPage({super.key});

  @override
  State<HomebuttonnavigationPage> createState() =>
      _HomebuttonnavigationPageState();
}

class _HomebuttonnavigationPageState extends State<HomebuttonnavigationPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Badge(
              alignment: Alignment.topRight,
              label: Text("1"),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Detail", icon: Icon(Icons.details)),
          BottomNavigationBarItem(
            label: "About",
            icon: Icon(Icons.account_box_outlined),
          ),
        ],
        onTap: (value) => (setState(() {
          _selectedIndex = value;
        })),
      ),
      body: [
        ProductListWidget(),
        ProductListWidget(),
        // ProductWidget(),
        Center(child: Text("About Author")),
      ][_selectedIndex],
    );
  }
}
