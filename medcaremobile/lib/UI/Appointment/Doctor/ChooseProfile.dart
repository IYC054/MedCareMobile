import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseDoctor.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseDoctorVIP.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/CreatePatientInformation.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/GetProfileApi.dart';
import 'package:medcaremobile/services/StorageService.dart';

class ChooseProfile extends StatefulWidget {
  const ChooseProfile({super.key, required this.isVIP});
  final bool isVIP;
  @override
  State<StatefulWidget> createState() => ChooseProfileState();
}

class ChooseProfileState extends State<ChooseProfile> {
  List<dynamic> profiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  static Map<String, dynamic>? user;

  // Method to load user data asynchronously
  Future<void> loadUserData() async {
    user = await StorageService.getUser();
    if (user != null) {
      print("Lấy user Data: $user");
      fetchProfiles(); // Gọi fetchProfiles sau khi user đã có dữ liệu
    } else {
      print("Không tìm thấy dữ liệu bệnh nhân.");
      setState(() {
        isLoading = false; // Dừng loading nếu không có user
      });
    }
  }

  void fetchProfiles() async {
    try {
      if (user == null) {
        loadUserData();
      }
      final fetchedProfiles =
          await Getprofileapi().getProfileByUserid(user?['id']);
      print(
          "Dữ liệu nhận được từ API: $fetchedProfiles"); // Kiểm tra dữ liệu API trả về
      if (fetchedProfiles != null && fetchedProfiles is List) {
        setState(() {
          profiles = fetchedProfiles;
        });
        print(
            "Danh sách hồ sơ sau khi cập nhật: $profiles"); // Kiểm tra danh sách sau khi setState
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu hồ sơ: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt khám'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(currentStep: 1),
            SizedBox(height: 24),
            Text(
              'Đặt khám',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddCard(),
                SizedBox(height: 16),
              ],
            ),
            Flexible(
              flex: 3,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: profiles.length, // Thêm 1 để chứa nút "Thêm"
                      itemBuilder: (context, index) {
                        final profile =
                            profiles[index]; // Lấy profile từ danh sách
                        String maskedPhone = profile['phone'] != null &&
                                profile['phone'].length > 3
                            ? "******" + profile['phone'].substring(6).trim()
                            : "******";
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.isVIP) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Choosedoctorvip(
                                            profileId: profile['id'],
                                            patientname: profile['fullname'],
                                            isVIP: widget.isVIP,
                                          )),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Choosedoctor(
                                            profileId: profile['id'],
                                            patientname: profile['fullname'],
                                          )),
                                );
                              }
                            },
                            child: _buildProfileCard(
                              profile['fullname'],
                              maskedPhone,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 24),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.home, color: Colors.white),
                label: Text(
                  'Quay lại',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCard() {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePatientInformation(
                              isVIP: widget.isVIP,
                            )));
              },
              child: Column(
                children: [
                  Icon(Icons.add, size: 32, color: Colors.blue),
                  SizedBox(height: 8),
                  Text('Thêm', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(String name, String phone) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.grey),
              SizedBox(width: 8),
              Text(phone),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom AppBar Widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // elevation: 0,
      title: Text(
        'Đặt khám',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      centerTitle: true,
      leading: Icon(Icons.arrow_back, color: Colors.black),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
