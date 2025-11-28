import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Màn hình Bài 3: Lưu trữ dữ liệu cục bộ với SharedPreferences
class Exercise3Screen extends StatefulWidget {
  const Exercise3Screen({super.key});

  @override
  State<Exercise3Screen> createState() => _Exercise3ScreenState();
}

class _Exercise3ScreenState extends State<Exercise3Screen> {
  // Controllers cho các TextField
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  String _displayName = 'Chưa có dữ liệu';
  String _displayAge = '';
  String _displayEmail = '';
  String _lastSavedTime = '';

  // Các khóa (key) để lưu trữ dữ liệu trong SharedPreferences
  static const String _nameKey = 'user_name';
  static const String _ageKey = 'user_age';
  static const String _emailKey = 'user_email';
  static const String _timestampKey = 'saved_timestamp';

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu đã lưu khi màn hình khởi động
    _loadData();
  }

  // Hàm tải dữ liệu từ SharedPreferences và cập nhật UI
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString(_nameKey) ?? 'Chưa có dữ liệu';
      _displayAge = 'Tuổi: ${prefs.getInt(_ageKey) ?? 'N/A'}';
      _displayEmail = 'Email: ${prefs.getString(_emailKey) ?? 'N/A'}';
      final timestamp = prefs.getInt(_timestampKey);
      if (timestamp != null) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        _lastSavedTime = 'Lưu lần cuối: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime)}';
      } else {
        _lastSavedTime = '';
      }
    });
  }

  // Hàm lưu dữ liệu từ TextFields vào SharedPreferences
  Future<void> _saveData() async {
    if (_nameController.text.isEmpty && _ageController.text.isEmpty && _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập ít nhất một thông tin để lưu!')),
      );
      return;
    }

    // Lấy instance và lưu dữ liệu
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, _nameController.text);
    await prefs.setInt(_ageKey, int.tryParse(_ageController.text) ?? 0);
    await prefs.setString(_emailKey, _emailController.text);
    await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);

    _nameController.clear();
    _ageController.clear();
    _emailController.clear();
    FocusScope.of(context).unfocus(); // Ẩn bàn phím

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu dữ liệu thành công!')),
    );
    // Tải lại dữ liệu để cập nhật UI
    _loadData();
  }

  // Hàm xóa toàn bộ dữ liệu người dùng đã lưu
  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_ageKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_timestampKey);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa toàn bộ dữ liệu!')),
    );
    // Tải lại dữ liệu để làm mới UI
    _loadData();
  }

  @override
  // Dọn dẹp controllers khi widget bị hủy
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 3: SharedPreferences'),
      ),
      // Sử dụng SingleChildScrollView để tránh lỗi tràn màn hình khi bàn phím hiện lên
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Phần hiển thị dữ liệu
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_displayName, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(_displayAge),
                    Text(_displayEmail),
                    const SizedBox(height: 16),
                    if (_lastSavedTime.isNotEmpty)
                      Text(_lastSavedTime, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Phần nhập liệu
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nhập tên', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Nhập tuổi', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Nhập email', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            // Các nút hành động
            ElevatedButton.icon(onPressed: _saveData, icon: const Icon(Icons.save), label: const Text('Lưu thông tin')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Hiển thị/Tải lại')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearData,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Xóa tất cả'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}