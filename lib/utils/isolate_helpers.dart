import 'dart:async';
import 'dart:isolate';
import 'dart:math';

/// Isolate này sẽ gửi một số ngẫu nhiên về cho isolate chính mỗi giây.
void sumIsolateEntry(SendPort mainSendPort) {
  final isolateReceivePort = ReceivePort();
  // Gửi SendPort của isolate phụ này về cho isolate chính
  // để isolate chính có thể gửi lệnh 'stop'
  mainSendPort.send(isolateReceivePort.sendPort);

  // Tạo một bộ đếm thời gian (timer) chạy mỗi giây
  final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    final randomNumber = Random().nextInt(10) + 1; // Số ngẫu nhiên từ 1 đến 10
    print('[Isolate Phụ] Gửi số: $randomNumber');
    mainSendPort.send(randomNumber);
  });

  // Lắng nghe lệnh stop từ isolate chính
  isolateReceivePort.listen((message) {
    if (message == 'stop') {
      print('[Isolate Phụ] Nhận được lệnh dừng. Đang thoát...');
      timer.cancel(); // Hủy timer
      isolateReceivePort.close(); // Đóng port
    } 
  });
}