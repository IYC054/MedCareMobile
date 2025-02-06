import 'package:flutter/material.dart';

class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text(
          "👨‍⚕️ Danh sách bác sĩ trực Tết",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  "https://cdn.medpro.vn/prod-partner/32ed13ae-ac57-4bc7-8573-7f19ae4b141c-medpro-an-khang-desktop.webp?w=1200&q=75",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Lo ngại vấn đề sức khỏe dịp Tết, gọi video với bác sĩ ngay trên Medpro",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "18/01/2023, 02:38 - NGUYEN CAM",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tết bị bệnh mà bệnh viện, phòng khám đều nghỉ. Đừng lo, Gọi video trực tiếp với bác sĩ ngay trên nền tảng Medpro - Đặt khám nhanh!",
                style: TextStyle(fontSize: 16),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
