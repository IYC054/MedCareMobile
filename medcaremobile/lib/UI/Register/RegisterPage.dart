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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Register/Header.dart';

class RegisterPage extends StatefulWidget {
  final TextEditingController emailController;

  const RegisterPage({super.key, required this.emailController});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _gender = 'Male';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Xử lý đăng ký ở đây
      print("Full Name: ${_fullNameController.text}");
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
      print("Date of Birth: ${_dobController.text}");
      print("Gender: $_gender");
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: Text("Register")),
    //   body: Padding(
    //     padding: EdgeInsets.all(16.0),
    //     child: Form(
    //       key: _formKey,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           TextFormField(
    //             controller: _fullNameController,
    //             decoration: InputDecoration(labelText: 'Full Name'),
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return 'Please enter your full name';
    //               }
    //               return null;
    //             },
    //           ),
    //           TextFormField(
    //             controller: _emailController,
    //             decoration: InputDecoration(labelText: 'Email'),
    //             keyboardType: TextInputType.emailAddress,
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return 'Please enter your email';
    //               } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    //                 return 'Enter a valid email';
    //               }
    //               return null;
    //             },
    //           ),
    //           TextFormField(
    //             controller: _passwordController,
    //             decoration: InputDecoration(labelText: 'Password'),
    //             obscureText: true,
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return 'Please enter your password';
    //               } else if (value.length < 6) {
    //                 return 'Password must be at least 6 characters';
    //               }
    //               return null;
    //             },
    //           ),
    //           TextFormField(
    //             controller: _confirmPasswordController,
    //             decoration: InputDecoration(labelText: 'Confirm Password'),
    //             obscureText: true,
    //             validator: (value) {
    //               if (value != _passwordController.text) {
    //                 return 'Passwords do not match';
    //               }
    //               return null;
    //             },
    //           ),
    //           TextFormField(
    //             controller: _dobController,
    //             decoration: InputDecoration(
    //               labelText: 'Date of Birth',
    //               suffixIcon: IconButton(
    //                 icon: Icon(Icons.calendar_today),
    //                 onPressed: () => _selectDate(context),
    //               ),
    //             ),
    //             readOnly: true,
    //           ),
    //           SizedBox(height: 10),
    //           Text("Gender"),
    //           Row(
    //             children: [
    //               Expanded(
    //                 child: RadioListTile<String>(
    //                   title: Text("Male"),
    //                   value: "Male",
    //                   groupValue: _gender,
    //                   onChanged: (value) {
    //                     setState(() {
    //                       _gender = value!;
    //                     });
    //                   },
    //                 ),
    //               ),
    //               Expanded(
    //                 child: RadioListTile<String>(
    //                   title: Text("Female"),
    //                   value: "Female",
    //                   groupValue: _gender,
    //                   onChanged: (value) {
    //                     setState(() {
    //                       _gender = value!;
    //                     });
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //           SizedBox(height: 20),
    //           Center(
    //             child: ElevatedButton(
    //               onPressed: _submitForm,
    //               child: Text("Register"),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
                            },
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
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: Text("Register"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    )
                )
              ],
            ),
          ),
        ));
  }
}
