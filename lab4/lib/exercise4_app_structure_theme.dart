import 'package:flutter/material.dart';

/// Exercise 4 – App Structure with Scaffold, AppBar, FAB & Theme
/// Goal: Practice building a complete screen structure with Dark Mode toggle.
class AppStructureTheme extends StatefulWidget {
  const AppStructureTheme({super.key});

  @override
  State<AppStructureTheme> createState() => _AppStructureThemeState();
}

class _AppStructureThemeState extends State<AppStructureTheme> {
  bool _isDarkMode = false;

  int _fabCount = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = _isDarkMode
        ? ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          )
        : ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
          );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 4 – App Structure & Theme'),
          backgroundColor: theme.colorScheme.inversePrimary,
          actions: [
            Row(
              children: [
                const Text('Dark'),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _isDarkMode ? 'Dark Mode is ON' : 'Light Mode is ON',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a simple screen with theme toggle.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'FAB tapped: $_fabCount time(s)',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _fabCount++;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('FAB pressed! Count: $_fabCount'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
