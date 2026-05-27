import 'package:flutter/material.dart';

/// Exercise 5 – Debug & Fix Common UI Errors
/// Goal: Understand common layout issues and fix them.
///
/// Các lỗi đã sửa:
/// 1. ListView inside Column → bọc bằng Expanded để tránh lỗi unbounded height
/// 2. Overflow trên màn nhỏ → dùng SingleChildScrollView
/// 3. State update không re-render → gọi setState() đúng cách
/// 4. DatePicker gọi ngoài widget tree → gọi từ valid BuildContext
class CommonUIFixes extends StatefulWidget {
  const CommonUIFixes({super.key});

  @override
  State<CommonUIFixes> createState() => _CommonUIFixesState();
}

class _CommonUIFixesState extends State<CommonUIFixes> {
  // ── Fix 3: State update issue ────────────────────────────────────────────
  // Biến đếm – phải gọi setState() mới re-render được
  int _counter = 0;

  // ── Fix 4: DatePicker context ────────────────────────────────────────────
  // Ngày được chọn – gọi showDatePicker từ valid widget context
  DateTime? _pickedDate;

  /// Fix 4: Gọi DatePicker từ valid context (bên trong build method)
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, // Context hợp lệ từ widget tree
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Fix 3: Dùng setState() để cập nhật UI sau khi chọn ngày
      setState(() {
        _pickedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── Fix 2: Overflow → bọc toàn bộ body bằng SingleChildScrollView ──────
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // SingleChildScrollView ngăn overflow trên màn hình nhỏ
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── FIX 1: ListView inside Column ─────────────────────────────
            // LỖI gốc: đặt ListView trực tiếp trong Column → lỗi unbounded height
            // SỬA: bọc ListView bằng Expanded (hoặc dùng SizedBox chiều cao cố định)
            const Text(
              'Fix 1: Correct ListView inside Column using Expanded',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // SizedBox cố định chiều cao thay cho Expanded (vì dùng SingleChildScrollView)
            SizedBox(
              height: 220,
              child: ListView(
                // Đây là ListView đúng cách trong Column:
                // dùng SizedBox/Expanded để giới hạn chiều cao
                children: const [
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie A')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie B')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie C')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie D')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie E')),
                ],
              ),
            ),

            const Divider(height: 32),

            // ── FIX 2: Overflow đã được xử lý ─────────────────────────────
            const Text(
              'Fix 2: Overflow fixed with SingleChildScrollView',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toàn bộ màn hình này được bọc bằng SingleChildScrollView, '
              'nên sẽ không bị tràn nội dung dù màn hình nhỏ.',
              style: TextStyle(color: Colors.grey),
            ),

            const Divider(height: 32),

            // ── FIX 3: State update với setState() ────────────────────────
            const Text(
              'Fix 3: State update fixed by calling setState()',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // setState() đảm bảo Flutter rebuild widget khi state thay đổi
                    setState(() {
                      _counter++;
                    });
                  },
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 16),
                Text('Count: $_counter', style: const TextStyle(fontSize: 16)),
              ],
            ),

            const Divider(height: 32),

            // ── FIX 4: DatePicker từ valid context ────────────────────────
            const Text(
              'Fix 4: DatePicker called from valid widget context',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              // Truyền context từ build() vào → đảm bảo context hợp lệ
              onPressed: () => _showDatePicker(context),
              child: const Text('Open Date Picker (fixed)'),
            ),
            const SizedBox(height: 8),
            Text(
              _pickedDate != null
                  ? 'Picked: ${_pickedDate!.day}/${_pickedDate!.month}/${_pickedDate!.year}'
                  : 'No date selected',
            ),
          ],
        ),
      ),
    );
  }
}
