import 'package:exam/Entity/Product.dart';
import 'package:flutter/material.dart';
import 'package:exam/Views/Widgets/ButtonBar.dart';
import 'package:exam/Views/Widgets/ProductWidget.dart';

class ProductDetailPage extends StatelessWidget {
  Product product;
  ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text("Product Detail")),
      ),
      bottomNavigationBar: Buttonbar(),
      body: ProductWidgetStateFull(product: product),
    );
  }
}
