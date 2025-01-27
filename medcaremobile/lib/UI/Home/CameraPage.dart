import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách camera có sẵn và khởi tạo controller cho camera đầu tiên
    availableCameras().then((cameras) {
      controller = CameraController(cameras[0], ResolutionPreset.high);
      _initializeControllerFuture = controller.initialize();
      setState(() {});
    }).catchError((e) {
      // print('Lỗi khi lấy camera: $e');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Không thể mở camera: ${snapshot.error}'));
          } else {
            return CameraPreview(controller);
          }
        },
      ),
    );
  }
}
