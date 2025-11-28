import 'package:flutter/material.dart';

// Màn hình Bài 4: Mô phỏng lập trình bất đồng bộ
class Exercise4Screen extends StatefulWidget {
  const Exercise4Screen({super.key});

  @override
  State<Exercise4Screen> createState() => _Exercise4ScreenState();
}

class _Exercise4ScreenState extends State<Exercise4Screen> {
  // State để quản lý trạng thái loading và thông báo
  bool _isLoading = true;
  String _message = 'Loading user...';

  @override
  void initState() {
    super.initState();
    // Bắt đầu tải dữ liệu khi màn hình khởi động
    _loadUserData();
  }

  // Hàm mô phỏng việc tải dữ liệu người dùng một cách bất đồng bộ
  Future<void> _loadUserData() async {
    // Đảm bảo màn hình đang ở trạng thái loading
    setState(() {
      _isLoading = true;
      _message = 'Loading user...';
    });

    // Dùng Future.delayed để giả lập một tác vụ tốn thời gian (ví dụ: gọi API)
    await Future.delayed(const Duration(seconds: 3));

    // Sau khi chờ xong, cập nhật lại UI
    // Kiểm tra mounted để đảm bảo widget vẫn còn trong cây widget trước khi gọi setState
    if (mounted) {
      setState(() {
        _isLoading = false;
        _message = 'User loaded successfully!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 4: Async Programming'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị vòng xoay loading hoặc icon thành công tùy theo state
            if (_isLoading)
              const CircularProgressIndicator()
            else
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 20),
            // Hiển thị thông báo trạng thái
            Text(
              _message,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      // Nút FloatingActionButton để chạy lại tiến trình loading
      floatingActionButton: FloatingActionButton(
        onPressed: _loadUserData,
        tooltip: 'Reload',
        child: const Icon(Icons.replay),
      ),
    );
  }
}