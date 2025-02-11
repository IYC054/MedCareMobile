// import 'package:flutter/material.dart';
// import 'package:medcaremobile/UI/Register/InputWrapper.dart';
// import 'package:medcaremobile/UI/Register/Header.dart';
// class RegisterPage extends StatefulWidget{
//   final TextEditingController emailController;
//   RegisterPage({super.key, required this.emailController});
//
//   @override
//   State<StatefulWidget> createState() => _RegisterPageState();
// }
// class _RegisterPageState extends State<RegisterPage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: true,
//         body: SingleChildScrollView(
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   colors: [Colors.cyan, Colors.blueAccent],
//                   begin: Alignment.topCenter),
//             ),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Header(),
//                 Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(50),
//                             topRight: Radius.circular(50))),
//                     child: InputWrapper(emailController: widget.emailController,))
//               ],
//             ),
//           ),
//         ));
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Register/Header.dart';

class RegisterPage extends StatefulWidget {
  final TextEditingController emailController;

  const RegisterPage({super.key, required this.emailController});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  AccountAPIService accountAPIService = AccountAPIService();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  String _gender = "Male";
  List<String> _roles = ["PATIENTS"];
  File? _selectedImage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdateController.text =
            DateFormat("yyyy-MM-dd").format(pickedDate); // Sửa định dạng
      });
    }
  }

  // Hàm yêu cầu quyền truy cập ảnh
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status;
      if (await Permission.photos.isGranted) {
        return true; // Quyền đã được cấp
      } else {
        status = await Permission.photos.request(); // Yêu cầu quyền
        return status.isGranted;
      }
    }
    return true; // Trên iOS, Flutter SDK tự xử lý quyền
  }

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    bool isGranted = await _requestPermission(); // Kiểm tra quyền trước
    if (!isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bạn cần cấp quyền để chọn ảnh!")),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        // Xử lý đăng ký ở đây
        print("Full Name: ${_fullNameController.text}");
        print("Phone: ${_phoneController.text}");
        print("Password: ${_passwordController.text}");
        print("Date of Birth: ${_birthdateController.text}");
        print("Gender: $_gender");
      }
      try {
        setState(() => _isLoading = true);

        var response = await accountAPIService.registerAccount(
          email: widget.emailController.text,
          name: _fullNameController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          gender: _gender,
          birthdate: _birthdateController.text,
          roles: _roles,
          avatar: _selectedImage,
        );

        print("API Response: $response");

        if (response.containsKey('result') && response['result'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đăng ký thành công!"), backgroundColor: Colors.green),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(emailController: widget.emailController)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? "Đăng ký thất bại!"), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối đến server!"), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.blueAccent],
                  begin: Alignment.topCenter),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Header(),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    // child: _selectedImage != null
                                    //     ? Image.file(_selectedImage!)
                                    //     : Icon(
                                    //   Icons.account_circle,
                                    //   size: 100,
                                    //   color: Colors.grey,
                                    // ),
                                    child: Stack(
                                      alignment: Alignment
                                          .bottomRight, // Căn icon camera ở góc phải dưới
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey[300],
                                          backgroundImage:
                                              _selectedImage != null
                                                  ? FileImage(_selectedImage!)
                                                  : null,
                                          child: _selectedImage == null
                                              ? Icon(
                                                  Icons.account_circle,
                                                  size: 100,
                                                  color: Colors.grey,
                                                )
                                              : Image.file(_selectedImage!),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .black, // Màu nền của icon camera
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: widget.emailController,
                              enabled: false,
                              // decoration: InputDecoration(
                              //     hintText: "Nhập email ",
                              //     hintStyle: TextStyle(color: Colors.grey),
                              //     border: InputBorder.none
                              // ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    Colors.grey[200], // Màu nền giống ảnh mẫu
                              ),
                            ),
                            TextFormField(
                              controller: _fullNameController,
                              decoration:
                                  InputDecoration(labelText: 'Họ và Tên'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập họ và tên';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _phoneController,
                              decoration:
                                  InputDecoration(labelText: 'Số điện thoại'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập số điện thoại';
                                }
                                final RegExp phoneRegex =
                                    RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$');
                                if (!phoneRegex.hasMatch(value)) {
                                  return 'Số điện thoại không hợp lệ';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                suffixIcon: IconButton(
                                  icon: Icon(_isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText:
                                  !_isPasswordVisible, // Ẩn/hiện mật khẩu
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                } else if (value.length < 6) {
                                  return 'Mật khẩu phải chứa ít nhất 6 ký tự';
                                } else if (!RegExp(
                                        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
                                    .hasMatch(value)) {
                                  return 'Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                suffixIcon: IconButton(
                                  icon: Icon(_isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_isConfirmPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng xác nhận mật khẩu';
                                } else if (value != _passwordController.text) {
                                  return 'Mật khẩu không trùng khớp';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                                controller: _birthdateController,
                                decoration: InputDecoration(
                                  labelText: 'Ngày sinh',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context),
                                  ),
                                ),
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn ngày sinh';
                                  }

                                  try {
                                    // Chuyển đổi định dạng ngày nếu cần
                                    DateTime birthdate = DateTime.parse(
                                        value); // value: 'yyyy-MM-dd'
                                    DateTime today = DateTime.now();
                                    int age = today.year - birthdate.year;

                                    // Kiểm tra nếu ngày sinh lớn hơn ngày hiện tại
                                    if (birthdate.isAfter(today)) {
                                      return 'Ngày sinh không hợp lệ';
                                    }

                                    // Kiểm tra tuổi tối thiểu (ví dụ: 18 tuổi)
                                    if (age < 18 ||
                                        (age == 18 &&
                                            today.isBefore(birthdate.add(
                                                Duration(days: 365 * age))))) {
                                      return 'Bạn phải từ 18 tuổi trở lên';
                                    }
                                  } catch (e) {
                                    return 'Định dạng ngày không hợp lệ';
                                  }

                                  return null;
                                }),
                            SizedBox(height: 10),
                            Text("Gender"),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: Text("Male"),
                                    value: "Male",
                                    groupValue: _gender,
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: Text("Female"),
                                    value: "Female",
                                    groupValue: _gender,
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: _isLoading ? null : _submitForm,
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color:
                                        _isLoading ? Colors.grey : Colors.cyan,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            "Đăng ký",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
