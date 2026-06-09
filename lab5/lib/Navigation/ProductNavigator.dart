import 'package:exam/Entity/Product.dart';
import 'package:exam/Views/Pages/ProductDetailPage.dart';
import 'package:exam/Views/Pages/ProductDetailViewPage.dart';
import 'package:flutter/material.dart';

/// Điều hướng sang trang chi tiết khi người dùng chọn sản phẩm.
class ProductNavigator {
  /// Mở trang ProductDetailPage gốc (giữ nguyên code gốc).
  static void openOriginalDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  /// Mở trang chi tiết mới (ProductDetailViewPage).
  static void openDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailViewPage(product: product),
      ),
    );
  }
}
