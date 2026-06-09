import 'package:exam/ViewModel/ProductService.dart';
import 'package:exam/Views/Pages/AboutPage.dart';
import 'package:exam/Views/Pages/HomePageNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:exam/Views/Pages/HomePage.dart';
import 'package:exam/Views/Pages/ProductDetailPage.dart';
import 'package:exam/Entity/Product.dart';
import 'Views/Pages/HomeButtonNavigationPage.dart';
import 'Views/Pages/HomeTabPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Product>? products;
  MyApp({super.key}) {
    Productservice productService = Productservice();
    products = productService.getAllProduct();
  }
  onPress() {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => Homepage(products: products!),
        //'/detail': (context) => ProductDetailPage(),
        '/about': (context) => AboutPage(),
      },

      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      // home: DefaultTabController(length: 3, child: HometabPage()),
      // home: AboutPage(),
    );
  }
}
