import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcaremobile/services/StorageService.dart'; // Import thư viện để định dạng ngày tháng

class PersonalProfile extends StatefulWidget {
  const PersonalProfile({super.key, required this.title});
  final String title;
  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  Map<String, dynamic>? userdata;
  bool isLoading = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _gender = "Nam"; // Mặc định là Nam
  DateTime? _selectedDate; // Ngày sinh đã chọn

  Future<void> _loadUserData() async {
    final user = await StorageService.getUser();
    if (user != null) {
      print("USER PROFILE $user");
      setState(() {
        userdata = user;
        _phoneController.text = user["phone"] ?? "";
        _firstNameController.text = user["name"] ?? "";
        _emailController.text = user["email"] ?? "";
        _gender = user["gender"] == "Male" ? "Nam" : "Nữ";
        _selectedDate = user["birthdate"] != null
            ? DateTime.parse(user["birthdate"])
            : null;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    print("user $userdata");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ảnh đại diện
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userdata?["name"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(userdata?["phone"],
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Các trường thông tin
            buildTextField("Số điện thoại", _phoneController, isReadOnly: true),
            buildTextField("Họ và tên đệm", _firstNameController),

            // Chọn ngày sinh + giới tính
            Row(
              children: [
                Expanded(child: buildDatePickerField("Ngày sinh")),
                const SizedBox(width: 16),
                Expanded(child: buildDropdownField("Giới tính")),
              ],
            ),
            const SizedBox(height: 16),
            buildTextField("Email", _emailController),

            const SizedBox(height: 24),

            // Nút cập nhật thông tin
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Xử lý cập nhật thông tin
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Cập nhật thông tin thành công!")),
                );
              },
              child: const Text("Cập nhật thông tin",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo ô nhập liệu
  Widget buildTextField(String label, TextEditingController controller,
      {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: isReadOnly ? Colors.grey[200] : Colors.white,
        ),
      ),
    );
  }

  // Widget chọn ngày sinh
  Widget buildDatePickerField(String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      controller: TextEditingController(
        text: _selectedDate == null
            ? ""
            : DateFormat('dd/MM/yyyy')
                .format(_selectedDate!), // Hiển thị ngày sinh
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime(2000, 1, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }

  // Widget dropdown chọn giới tính
  Widget buildDropdownField(String label) {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: ["Nam", "Nữ", "Khác"].map((String gender) {
        return DropdownMenuItem(value: gender, child: Text(gender));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _gender = newValue!;
        });
      },
    );
  }
}
