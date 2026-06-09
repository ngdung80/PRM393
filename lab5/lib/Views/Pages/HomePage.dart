import 'package:exam/Entity/Product.dart';
import 'package:exam/Views/Pages/AboutPage.dart';
import 'package:exam/Views/Widgets/ProductList.dart';
//import 'package:exam/Views/Widgets/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:exam/Views/Widgets/ButtonBar.dart';
import 'package:exam/Views/Widgets/Product_Widget.dart';

class Homepage1 extends StatelessWidget {
  const Homepage1({super.key});
  AboutOnPress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: AboutOnPress(context),
          icon: Icon(Icons.account_box_outlined),
        ),
      ),
      body: ProductListWidget(),
      bottomNavigationBar: Buttonbar(),
    );
  }
}

class Homepage extends StatefulWidget {
  List<Product> products;
  Homepage({super.key, required this.products});

  @override
  State<Homepage> createState() => _HomepageState(products: products);
}

class _HomepageState extends State<Homepage> {
  List<Product> products;
  _HomepageState({required this.products});
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        title: Center(child: Text("Home Page")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            icon: Icon(Icons.account_box_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/detail'),

            icon: Icon(Icons.details),
          ),
        ],
      ),
      body: [
        ProductListReponsive(products: products),
        Center(child: Text("About")),
        Center(child: Text("Detail product")),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.details), label: "Detail"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: "About",
          ),
        ],
      ),
    );
  }
}
