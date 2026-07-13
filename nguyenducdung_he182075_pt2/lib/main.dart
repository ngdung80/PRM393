import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/product_list_viewmodel.dart';
import 'views/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Cung cấp ProductListViewModel cho toàn bộ cây widget bên dưới
      create: (_) => ProductListViewModel(),
      child: MaterialApp(
        title: 'Products',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A73E8),
            primary: const Color(0xFF1A73E8),
            secondary: const Color(0xFF4A90E2),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF2F5FA),
          fontFamily: 'Roboto',
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}