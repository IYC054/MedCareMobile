import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputField extends StatefulWidget {
  TextEditingController emailController;
  final Function(Map<String, dynamic>) onUserDataChanged;

  InputField({required this.emailController, required this.onUserDataChanged, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  // value gioi tinh
  String? _gender;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handleUserData(); // Gửi dữ liệu ban đầu
  }
  void handleUserData() {
    Map<String, dynamic> userData = {
      "email": widget.emailController.text,
      "name": _fullNameController.text,
      "phone": _phoneController.text,
      "password": _passwordController.text,
      "birthdate": _dobController.text,
      "gender": _gender,
      "role": ["Patients"],
      "avatar": "null"
    };

    widget.onUserDataChanged(userData); // Gửi dữ liệu lên InputWrapper
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                fillColor: Colors.grey[200],  // Màu nền giống ảnh mẫu
              ),
            ),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              }
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone';
                }

                // Regex kiểm tra số điện thoại hợp lệ (Việt Nam hoặc quốc tế)
                final RegExp phoneRegex = RegExp(r'^(?:\+84|0)(?:[1-9][0-9]{8,9})$');

                if (!phoneRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid phone number';
                }
                return null; // ✅ Hợp lệ
              }
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
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
          ],
        ),
      ),
    );
    // return Column(
    //   children: <Widget>[
    //     Container(
    //       padding: EdgeInsets.all(5),
    //       // decoration: BoxDecoration(
    //       //     border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         style: TextStyle(color: Colors.black87),
    //         controller: widget.emailController,
    //         enabled: false,
    //         // decoration: InputDecoration(
    //         //     hintText: "Nhập email ",
    //         //     hintStyle: TextStyle(color: Colors.grey),
    //         //     border: InputBorder.none
    //         // ),
    //         decoration: InputDecoration(
    //           border: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           filled: true,
    //           fillColor: Colors.grey[200],  // Màu nền giống ảnh mẫu
    //         ),
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         decoration: InputDecoration(
    //             labelText: "Tên",
    //             hintText: "Nhập tên",
    //             hintStyle: TextStyle(color: Colors.grey),
    //             border: InputBorder.none),
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         decoration: InputDecoration(
    //             labelText: "Số điện thoại",
    //
    //             hintText: "Nhập số điện thoại",
    //             hintStyle: TextStyle(color: Colors.grey),
    //             border: InputBorder.none),
    //       ),
    //     ),
    //     // Container(
    //     //   padding: EdgeInsets.all(10),
    //     //   decoration: BoxDecoration(
    //     //       border: Border(bottom: BorderSide(color: Colors.grey))),
    //     //   child: DropdownButtonFormField<String>(
    //     //     value: selectedGender, // Giá trị được chọn
    //     //     onChanged: (String? newValue) {
    //     //       setState(() {
    //     //         selectedGender = newValue;
    //     //       });
    //     //     },
    //     //     decoration: InputDecoration(
    //     //       labelText: "Giới tính",
    //     //       hintText: "Chọn giới tính",
    //     //       hintStyle: TextStyle(color: Colors.grey),
    //     //       border: InputBorder.none,
    //     //     ),
    //     //     items: <String>['Nam', 'Nữ']
    //     //         .map<DropdownMenuItem<String>>((String value) {
    //     //       return DropdownMenuItem<String>(
    //     //         value: value,
    //     //         child: Text(value),
    //     //       );
    //     //     }).toList(),
    //     //   ),
    //     // ),
    //
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //         border: Border(bottom: BorderSide(color: Colors.grey)),
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             "Giới tính",
    //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //           ),
    //           Row(
    //             children: [
    //               Radio<String>(
    //                 value: "Male",
    //                 groupValue: selectedGender,
    //                 onChanged: (String? value) {
    //                   setState(() {
    //                     selectedGender = value;
    //                   });
    //                 },
    //               ),
    //               Text("Nam"),
    //               SizedBox(width: 20), // Tạo khoảng cách giữa 2 radio
    //               Radio<String>(
    //                 value: "Female",
    //                 groupValue: selectedGender,
    //                 onChanged: (String? value) {
    //                   setState(() {
    //                     selectedGender = value;
    //                   });
    //                 },
    //               ),
    //               Text("Nữ"),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         controller: _datecontroller,
    //         decoration: InputDecoration(
    //           labelText: "Ngày sinh",
    //           filled: true,
    //           prefixIcon: Icon(Icons.calendar_today),
    //           enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
    //           focusedBorder: OutlineInputBorder(
    //               borderSide: BorderSide(color: Colors.blue)),
    //         ),
    //         readOnly: true,
    //         onTap: () => {_selectDate()},
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         obscureText: true,
    //         decoration: InputDecoration(
    //             labelText: "Mật khẩu",
    //             hintText: "Nhập mật khẩu",
    //             hintStyle: TextStyle(color: Colors.grey),
    //             border: InputBorder.none),
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         obscureText: true,
    //         decoration: InputDecoration(
    //             labelText: "Xác nhận mật khẩu",
    //             hintText: "Xác nhận mật khẩu",
    //             hintStyle: TextStyle(color: Colors.grey),
    //             border: InputBorder.none),
    //       ),
    //     ),
    //   ],
    // );
  }
}
