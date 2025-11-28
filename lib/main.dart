import 'package:flutter/material.dart';
// Import các màn hình bài tập
import 'package:lt/screens/exercise_1_listview.dart';
import 'package:lt/screens/exercise_2_gridview.dart';
import 'package:lt/screens/exercise_3_shared_prefs.dart';
import 'package:lt/screens/exercise_4_async.dart';
import 'package:lt/screens/exercise_5_isolates.dart';

// Hàm main, điểm bắt đầu của ứng dụng
void main() {
  runApp(const MyApp());
}

// Widget gốc của ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài tập tuần 4',
      // Cấu hình theme chung cho ứng dụng
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      // Màn hình chính khi khởi động
      home: const MainMenuScreen(),
    );
  }
}

// Màn hình menu chính để điều hướng đến các bài tập
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  // Widget trợ giúp để tạo một nút trong menu
  Widget _buildMenuButton(
      BuildContext context, String title, Widget destination) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập tuần 4 - Menu'),
      ),
      // Danh sách các nút điều hướng
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildMenuButton(context, 'Bài 1: ListView', const Exercise1Screen()),
          _buildMenuButton(context, 'Bài 2: GridView', const Exercise2Screen()),
          _buildMenuButton(
              context, 'Bài 3: SharedPreferences', const Exercise3Screen()),
          _buildMenuButton(context, 'Bài 4: Asynchronous Programming',
              const Exercise4Screen()),
          _buildMenuButton(context, 'Bài 5: Isolates', const Exercise5Screen()),
        ],
      ),
    );
  }
}
