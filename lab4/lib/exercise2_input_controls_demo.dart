import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;

  bool _isActive = false;

  String? _selectedGenre;

  DateTime? _selectedDate;

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Controls Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _sliderValue.round().toString(),
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text('Current value: ${_sliderValue.round()}'),

            const SizedBox(height: 24),

            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Is movie active?'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioGroup<String>(
              groupValue: _selectedGenre,
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Action'),
                    value: 'Action',
                  ),
                  RadioListTile<String>(
                    title: const Text('Comedy'),
                    value: 'Comedy',
                  ),
                  RadioListTile<String>(
                    title: const Text('Drama'),
                    value: 'Drama',
                  ),
                ],
              ),
            ),
            Text('Selected genre: ${_selectedGenre ?? 'None'}'),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: _openDatePicker,
                child: const Text('Open Date Picker'),
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedDate != null)
              Center(
                child: Text(
                  'Selected date: '
                  '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
