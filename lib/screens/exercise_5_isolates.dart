import 'dart:isolate';
import 'package:flutter/foundation.dart'; // For compute
import 'package:flutter/material.dart';
import 'package:lt/utils/isolate_helpers.dart';

// Màn hình Bài 5: Xử lý đa luồng với Isolates
class Exercise5Screen extends StatefulWidget {
  const Exercise5Screen({super.key});

  @override
  State<Exercise5Screen> createState() => _Exercise5ScreenState();
}

class _Exercise5ScreenState extends State<Exercise5Screen> {
  // State cho Challenge 1: Tính giai thừa
  bool _isCalculating = false;
  String _factorialResult = 'Kết quả sẽ hiển thị ở đây.';

  // State cho Challenge 2: Cộng dồn số ngẫu nhiên
  bool _isIsolateRunning = false;
  int _currentSum = 0;
  Isolate? _sumIsolate;
  ReceivePort? _receivePort;
  Stream<dynamic>? _broadcastStream;

  // Hàm tính giai thừa (để chạy trên isolate)
  static BigInt _calculateFactorial(int n) { // Phải là hàm static hoặc top-level
    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  // Bắt đầu tính giai thừa bằng hàm `compute`
  Future<void> _startFactorialCalculation() async {
    setState(() {
      _isCalculating = true;
      _factorialResult = 'Đang tính giai thừa của 30000...';
    });

    // `compute` sẽ chạy hàm _calculateFactorial trên một isolate riêng
    // và trả về kết quả khi hoàn thành.
    final result = await compute(_calculateFactorial, 30000);

    setState(() {
      _isCalculating = false;
      // Kết quả quá lớn để hiển thị, chỉ hiển thị số chữ số
      _factorialResult = 'Giai thừa của 30000 có ${result.toString().length} chữ số.';
    });
  }

  // Bắt đầu Challenge 2: Tạo và lắng nghe isolate cộng dồn
  void _startSumIsolate() async {
    if (_isIsolateRunning) return;

    setState(() {
      _isIsolateRunning = true;
      _currentSum = 0;
    });

    _receivePort = ReceivePort();
    // Chuyển ReceivePort thành broadcast stream để có thể lắng nghe nhiều lần
    _broadcastStream = _receivePort!.asBroadcastStream();

    // Tạo isolate mới
    _sumIsolate = await Isolate.spawn(
      sumIsolateEntry, // Hàm entry point trong file helper
      _receivePort!.sendPort,
    );

    // Lắng nghe tin nhắn từ isolate phụ
    _broadcastStream!.listen((message) {
      if (message is int) {
        setState(() {
          _currentSum += message;
        });
        // Nếu tổng > 100, gửi lệnh dừng
        if (_currentSum > 100 && _sumIsolate != null) {
          // Gửi SendPort của isolate phụ để nó có thể tự đóng
          _broadcastStream!.firstWhere((msg) => msg is SendPort).then((sendPort) {
            sendPort.send('stop');
            _stopSumIsolate();
          });
        }
      }
    });
  }

  // Dừng và dọn dẹp isolate của Challenge 2
  void _stopSumIsolate() {
    _sumIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    setState(() {
      _isIsolateRunning = false;
      _sumIsolate = null;
      _receivePort = null;
    });
  }

  @override
  void dispose() {
    _stopSumIsolate(); // Đảm bảo isolate được dọn dẹp khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng TabController để quản lý 2 challenge
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bài 5: Isolates'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Challenge 1: Factorial'),
              Tab(text: 'Challenge 2: Sum'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Giao diện cho Challenge 1
            _buildFactorialChallenge(),
            // Giao diện cho Challenge 2
            _buildSumChallenge(),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng giao diện cho Challenge 1
  Widget _buildFactorialChallenge() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tính giai thừa của một số lớn (30,000) mà không làm đóng băng UI bằng cách sử dụng hàm `compute`.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_isCalculating)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _startFactorialCalculation,
              child: const Text('Bắt đầu tính toán'),
            ),
          const SizedBox(height: 20),
          Text(
            _factorialResult,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  // Widget xây dựng giao diện cho Challenge 2
  Widget _buildSumChallenge() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Isolate phụ gửi số ngẫu nhiên mỗi giây. Isolate chính cộng dồn tổng. Khi tổng > 100, isolate chính gửi lệnh dừng.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Tổng hiện tại: $_currentSum',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          if (_isIsolateRunning)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _startSumIsolate,
              child: const Text('Bắt đầu Isolate'),
            ),
          if (_isIsolateRunning)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: OutlinedButton(
                onPressed: _stopSumIsolate,
                child: const Text('Dừng Isolate'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}