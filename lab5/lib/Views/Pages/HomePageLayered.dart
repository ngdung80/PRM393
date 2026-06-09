import 'package:exam/Entity/Product.dart';
import 'package:exam/Views/Pages/AboutPage.dart';
import 'package:exam/Views/Widgets/ProductListLayered.dart';
import 'package:flutter/material.dart';

/// Home page dùng Product List layers (file mới, không sửa HomePage.dart gốc).
class HomePageLayered extends StatefulWidget {
  final List<Product> products;

  const HomePageLayered({super.key, required this.products});

  @override
  State<HomePageLayered> createState() => _HomePageLayeredState();
}

class _HomePageLayeredState extends State<HomePageLayered> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const Center(child: Text('Fresh Food')),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/about'),
            icon: const Icon(Icons.account_box_outlined),
          ),
        ],
      ),
      body: [
        ProductListLayeredResponsive(products: widget.products),
        const AboutPage(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Chọn một sản phẩm từ tab Trang chủ để xem chi tiết.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ),
        ),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Giới thiệu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Hướng dẫn',
          ),
        ],
      ),
    );
  }
}
