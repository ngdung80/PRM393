import 'package:flutter/material.dart';

import '../Widgets/Product_Widget.dart';

class HometabPage extends StatefulWidget {
  const HometabPage({super.key});

  @override
  State<HometabPage> createState() => _HometabPageState();
}

class _HometabPageState extends State<HometabPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.details)),
            Tab(icon: Icon(Icons.account_box_outlined)),
          ],

          onTap: (int index) {
            _selectedIndex = index;
          },
        ),
      ),
      body: TabBarView(
        children: [
          ProductListWidget(),
          ProductListWidget(),
          //  ProductWidget(),
          Center(child: Text("About Author")),
        ],
      ),
    );
  }
}
