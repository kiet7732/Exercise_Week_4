import 'package:flutter/material.dart';

// Màn hình Bài 2: Hiển thị 2 loại GridView
class Exercise2Screen extends StatelessWidget {
  const Exercise2Screen({super.key});

  // Widget trợ giúp để tạo một mục trong grid
  Widget _buildGridItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            'Item ${index + 1}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget trợ giúp để tạo tiêu đề cho mỗi phần
  Widget _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 2: GridView'),
      ),
      // Sử dụng CustomScrollView để kết hợp nhiều loại view cuộn
      body: CustomScrollView(
        slivers: [
          _buildHeader('Fixed Column Grid'),
          // Phần 1: GridView với số cột cố định
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,         // 3 cột
                mainAxisSpacing: 8,        // Khoảng cách hàng
                crossAxisSpacing: 8,       // Khoảng cách cột
                childAspectRatio: 1.0,     // Tỷ lệ khung hình
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildGridItem(index),
                childCount: 6, // Hiển thị 6 item
              ),
            ),
          ),

          _buildHeader('Responsive Grid'),
          // Phần 2: GridView đáp ứng (responsive) dựa trên chiều rộng tối đa
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,  // Chiều rộng tối đa của mỗi item
                mainAxisSpacing: 10,      // Khoảng cách hàng
                crossAxisSpacing: 10,     // Khoảng cách cột
                childAspectRatio: 0.8,    // Tỷ lệ khung hình
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildGridItem(index + 6), // Tiếp tục index
                childCount: 6, // Hiển thị 6 item
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}