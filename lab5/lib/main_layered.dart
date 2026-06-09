import 'package:exam/ViewModel/ProductListPresenter.dart';
import 'package:exam/Views/Pages/AboutPage.dart';
import 'package:exam/Views/Pages/HomePageLayered.dart';
import 'package:exam/Views/Pages/ProductDetailViewPage.dart';
import 'package:exam/Entity/Product.dart';
import 'package:flutter/material.dart';

/// Entry point dùng kiến trúc layers — không sửa main.dart gốc.
/// Chạy: flutter run -t lib/main_layered.dart
void main() {
  runApp(MyAppLayered());
}

class MyAppLayered extends StatelessWidget {
  final ProductListPresenter presenter = ProductListPresenter();

  MyAppLayered({super.key});

  @override
  Widget build(BuildContext context) {
    final products = presenter.loadProducts();

    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => HomePageLayered(products: products),
            );
          case '/about':
            return MaterialPageRoute(
              builder: (context) => const AboutPage(),
            );
          case '/detail':
            final product = settings.arguments as Product?;
            if (product == null) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Không tìm thấy sản phẩm')),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (context) => ProductDetailViewPage(product: product),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => HomePageLayered(products: products),
            );
        }
      },
    );
  }
}
