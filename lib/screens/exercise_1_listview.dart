import 'package:flutter/material.dart';

// Màn hình Bài 1: Hiển thị danh sách liên hệ bằng ListView
class Exercise1Screen extends StatelessWidget {
  const Exercise1Screen({super.key});

  // Dữ liệu giả cho danh sách liên hệ
  final List<Map<String, String>> contacts = const [
    {'name': 'Alice Johnson'},
    {'name': 'Bob Williams'},
    {'name': 'Charlie Brown'},
    {'name': 'Diana Miller'},
    {'name': 'Ethan Davis'},
    {'name': 'Fiona Garcia'},
    {'name': 'George Rodriguez'},
    {'name': 'Hannah Martinez'},
    {'name': 'Ian Hernandez'},
    {'name': 'Jane Lopez'},
    {'name': 'Kevin Gonzalez'},
    {'name': 'Laura Wilson'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 1: ListView'),
      ),
      // Sử dụng ListView.separated để tạo danh sách có dải phân cách
      body: ListView.separated(
        // itemCount xác định số lượng item trong danh sách
        itemCount: contacts.length,
        // itemBuilder: Xây dựng giao diện cho mỗi mục trong danh sách
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            // Hình đại diện placeholder
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[100],
              child: const Icon(Icons.person, color: Colors.white),
            ),
            // Tên liên hệ
            title: Text(contacts[index]['name']!),
            subtitle: Text('Contact #${index + 1}'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào một item
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on ${contacts[index]['name']}')),
              );
            },
          );
        },
        // separatorBuilder: Xây dựng dải phân cách giữa các mục
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16);
        },
      ),
    );
  }
}