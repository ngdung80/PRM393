import 'package:exam/ViewModel/ProductListPresenter.dart';
import 'package:exam/Views/Widgets/ProductListLayered.dart';
import 'package:flutter/material.dart';

/// Trang Product List hoàn chỉnh theo kiến trúc layers.
class ProductListPage extends StatelessWidget {
  final ProductListPresenter presenter;

  ProductListPage({super.key, ProductListPresenter? presenter})
      : presenter = presenter ?? ProductListPresenter();

  @override
  Widget build(BuildContext context) {
    final products = presenter.loadProducts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Danh sách sản phẩm')),
      ),
      body: ProductListLayeredResponsive(products: products),
    );
  }
}
