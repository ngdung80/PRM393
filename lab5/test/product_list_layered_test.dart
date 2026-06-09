import 'package:exam/Entity/Product.dart';
import 'package:exam/ViewModel/ProductListPresenter.dart';
import 'package:exam/Views/Pages/ProductDetailViewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ProductListPresenter loads products from repository', () {
    final presenter = ProductListPresenter();
    final products = presenter.loadProducts();

    expect(products, isNotEmpty);
    expect(products.length, Product.products.length);
  });

  testWidgets('ProductDetailViewPage shows selected product', (
    WidgetTester tester,
  ) async {
    final product = Product.products.first;

    await tester.pumpWidget(
      MaterialApp(home: ProductDetailViewPage(product: product)),
    );

    expect(find.text(product.name), findsWidgets);
    expect(find.textContaining(product.id), findsOneWidget);
  });
}
