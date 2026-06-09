import 'package:exam/Entity/Product.dart';
import 'package:exam/Views/Widgets/ProductListItem.dart';
import 'package:flutter/material.dart';

/// Danh sách sản phẩm theo layers (file mới, không sửa ProductList.dart gốc).
class ProductListLayered extends StatelessWidget {
  final List<Product> products;

  const ProductListLayered({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          ProductListItem(product: products[index]),
    );
  }
}

class ProductListLayeredResponsive extends StatelessWidget {
  final List<Product> products;

  const ProductListLayeredResponsive({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth <= 450 ? 1 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: crossAxisCount == 1 ? 3.2 : 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ProductListItem(product: products[index]),
        );
      },
    );
  }
}
