import 'package:flutter/material.dart';
import 'exercise1_core_widgets_demo.dart';
import 'exercise2_input_controls_demo.dart';
import 'exercise3_layout_demo.dart';
import 'exercise4_app_structure_theme.dart';
import 'exercise5_common_ui_fixes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 – Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {
        'title': 'Exercise 1 – Core Widgets Demo',
        'subtitle': 'Text, Image, Icon, Card, ListTile',
        'icon': Icons.widgets_outlined,
        'route': const CoreWidgetsDemo(),
      },
      {
        'title': 'Exercise 2 – Input Controls Demo',
        'subtitle': 'Slider, Switch, RadioListTile, DatePicker',
        'icon': Icons.tune_outlined,
        'route': const InputControlsDemo(),
      },
      {
        'title': 'Exercise 3 – Layout Demo',
        'subtitle': 'Column, Row, Padding, ListView',
        'icon': Icons.view_quilt_outlined,
        'route': const LayoutDemo(),
      },
      {
        'title': 'Exercise 4 – App Structure & Theme',
        'subtitle': 'Scaffold, AppBar, FAB, ThemeData, Dark Mode',
        'icon': Icons.architecture_outlined,
        'route': const AppStructureTheme(),
      },
      {
        'title': 'Exercise 5 – Common UI Fixes',
        'subtitle': 'ListView fix, overflow, setState, DatePicker context',
        'icon': Icons.build_outlined,
        'route': const CommonUIFixes(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundamentals'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Icon(
                ex['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                ex['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(ex['subtitle'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ex['route'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
