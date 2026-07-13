import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nguyenducdung_he182075_pt2/main.dart';

void main() {
  testWidgets('Product List App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is displayed
    expect(find.text('Khám Phá Sản Phẩm'), findsOneWidget);

    // Verify that the search bar exists
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Tìm kiếm sản phẩm...'), findsOneWidget);

    // Verify that mock products are loaded (e.g. 'iPhone 15 Pro Max' or 'MacBook Pro M3 Max')
    expect(find.text('iPhone 15 Pro Max'), findsOneWidget);
    expect(find.text('MacBook Pro M3 Max'), findsOneWidget);
  });
}
