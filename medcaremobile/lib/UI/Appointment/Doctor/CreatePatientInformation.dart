import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseProfile.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/CheckCCCDApi.dart';
import 'package:medcaremobile/services/ProvinceApi.dart';
import 'package:medcaremobile/services/PatientInformation.dart';
import 'package:intl/intl.dart';

class CreatePatientInformation extends StatefulWidget {
  const CreatePatientInformation({super.key, required this.isVIP});

  final bool isVIP;
  @override
  _CreatePatientInformationState createState() =>
      _CreatePatientInformationState();
}

class _CreatePatientInformationState extends State<CreatePatientInformation> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Map<String, dynamic>? _cccdData;
  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ethnicityController = TextEditingController();
  TextEditingController bhytController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? gender = "NAM";
  String? selectedProvinceId;
  String? selectedDistrictId;
  String? selectedWardId;
  String? selectedEthnicity;
  String? selectedJob;
  bool isCCCDUpdated = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Gửi ảnh lên API để lấy thông tin CCCD
      final response = await CheckCCCDAPI.getCCCD(_selectedImage!);
      if (response != null) {
        setState(() {
          _cccdData = response;
        });
        _updateCCCDFields();
      }
    }
  }

  // Cập nhật thông tin CCCD vào form
  void _updateCCCDFields() {
    if (_cccdData != null &&
        _cccdData!['data'] is List &&
        _cccdData!['data'].isNotEmpty) {
      var firstData = _cccdData!['data'][0];

      String rawDob = firstData['dob'] ?? '';

      DateTime? parsedDate;
      try {
        if (rawDob.contains('/')) {
          // Nếu định dạng là DD/MM/YYYY hoặc MM/DD/YYYY
          List<String> parts = rawDob.split('/');
          if (parts[2].length == 4) {
            parsedDate = DateFormat('dd/MM/yyyy').parse(rawDob);
          } else {
            parsedDate = DateFormat('MM/dd/yyyy').parse(rawDob);
          }
        } else if (rawDob.contains('-')) {
          // Nếu định dạng là YYYY-MM-DD (chuẩn)
          parsedDate = DateTime.parse(rawDob);
        }
      } catch (e) {
        print("Lỗi khi parse ngày tháng: $e");
        parsedDate = null;
      }

      setState(() {
        nameController.text = firstData['name'] ?? '';
        birthDateController.text = parsedDate != null
            ? "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}"
            : '';
        bhytController.text = firstData['id'] ?? '';
        gender = firstData['sex'] ?? '';
        isCCCDUpdated = true;
      });
    }
  }

  List<Map<String, String>> ethnicities = [
    {'id': '1', 'name': 'Kinh'},
    {'id': '2', 'name': 'Tày'},
    {'id': '3', 'name': 'Thái'},
    {'id': '4', 'name': 'Mường'},
  ];

  List<Map<String, String>> jobs = [
    {'id': '1', 'name': 'Bác sĩ'},
    {'id': '2', 'name': 'Kỹ sư'},
    {'id': '3', 'name': 'Giáo viên'},
    {'id': '4', 'name': 'Sinh viên'},
  ];
  List<Map<String, String>> provinces = [];
  List<Map<String, String>> districts = [];
  List<Map<String, String>> wards = [];

  @override
  void initState() {
    super.initState();
    fetchProvinces();
  }

  void createProfile() {}
  // Lấy danh sách tỉnh/thành
  void fetchProvinces() async {
    try {
      List<dynamic> provincesData = await Provinceapi.getProvinces();
      setState(() {
        provinces = provincesData.map((province) {
          return {
            'id': province['id'].toString(),
            'name': province['name'].toString()
          };
        }).toList();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // Lấy danh sách quận/huyện dựa trên tỉnh đã chọn
  void fetchDistricts(int provinceId) async {
    try {
      List<dynamic> districtsData = await Provinceapi.getDistricts(provinceId);
      setState(() {
        districts = districtsData.map((district) {
          return {
            'id': district['id'].toString(),
            'name': district['name'].toString()
          };
        }).toList();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // Lấy danh sách phường/xã dựa trên quận/huyện đã chọn
  void fetchWards(int districtId) async {
    try {
      List<dynamic> wardsData = await Provinceapi.getWards(districtId);
      setState(() {
        wards = wardsData.map((ward) {
          return {'id': ward['id'].toString(), 'name': ward['name'].toString()};
        }).toList();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  String getProvinceName(String? id) {
    if (id == null) return "";
    return provinces.firstWhere((p) => p['id'] == id,
        orElse: () => {'name': ''})['name']!;
  }

  String getDistrictName(String? id) {
    if (id == null) return "";
    return districts.firstWhere((d) => d['id'] == id,
        orElse: () => {'name': ''})['name']!;
  }

  String getWardName(String? id) {
    if (id == null) return "";
    return wards.firstWhere((w) => w['id'] == id,
        orElse: () => {'name': ''})['name']!;
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
        birthDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo hồ sơ khám bệnh")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProgressBar(currentStep: 1),
            SizedBox(height: 24),
            Form(
              key: _formKey, // Thêm key vào Form
              child: Column(
                children: [
                  // buildImagePicker(),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextField("Tên", nameController, isCCCDUpdated),
                  buildDatePickerField(
                      "Ngày sinh", birthDateController, isCCCDUpdated),
                  buildTextField("Số điện thoại", phoneController),
                  buildGenderField(),
                  buildDropdownField(
                    "Dân tộc",
                    ethnicities,
                    selectedEthnicity,
                    (value) {
                      setState(() {
                        selectedEthnicity = value;
                      });
                    },
                  ),
                  buildDropdownField(
                    "Nghề nghiệp",
                    jobs,
                    selectedJob,
                    (value) {
                      setState(() {
                        selectedJob = value;
                      });
                    },
                  ),
                  buildTextField("Email", emailController),
                  // buildTextField("Số CCCD", bhytController, isCCCDUpdated),
                  buildDropdownField(
                    "Tỉnh/Thành",
                    provinces,
                    selectedProvinceId,
                    (value) {
                      setState(() {
                        selectedProvinceId = value;
                        selectedDistrictId = null;
                        selectedWardId = null;
                        fetchDistricts(int.parse(value!));
                      });
                    },
                  ),
                  buildDropdownField(
                    "Quận/Huyện",
                    districts,
                    selectedDistrictId,
                    (value) {
                      setState(() {
                        selectedDistrictId = value;
                        selectedWardId = null;
                        fetchWards(int.parse(value!));
                      });
                    },
                  ),
                  buildDropdownField(
                    "Phường/Xã",
                    wards,
                    selectedWardId,
                    (value) {
                      setState(() {
                        selectedWardId = value;
                      });
                    },
                  ),
                  buildTextField("Địa chỉ hiện tại", addressController),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Vui lòng điền đầy đủ thông tin!')),
                        );
                        return;
                      }

                      // Kiểm tra nếu chưa chọn ảnh và chưa nhập địa chỉ đầy đủ
                      bool isImageSelected = _selectedImage != null;
                      bool isAddressFilled = selectedProvinceId != null &&
                          selectedDistrictId != null &&
                          selectedWardId != null;

                      if (!isImageSelected && !isAddressFilled) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Vui lòng chọn ảnh hoặc nhập đầy đủ địa chỉ!')),
                        );
                        return;
                      }

                      // Nếu đã chọn ảnh, không cần lấy địa chỉ
                      String formattedAddress = isImageSelected
                          ? "Không có địa chỉ"
                          : "${getProvinceName(selectedProvinceId ?? '')} "
                              "${getDistrictName(selectedDistrictId ?? '')} "
                              "${getWardName(selectedWardId ?? '')} "
                              "${addressController.text}";

                      int result =
                          await Patientinformation.createPatientInformation(
                        fullname: nameController.text,
                        birthdate: birthDateController.text,
                        phone: phoneController.text,
                        gender: gender ?? "",
                        codeBhyt: bhytController.text,
                        nation: ethnicityController.text,
                        address: formattedAddress,
                      );

                      if (result > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tạo hồ sơ thành công!')),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseProfile(
                                isVIP: widget.isVIP,
                              ),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tạo hồ sơ thất bại!')),
                        );
                      }
                    },
                    child: Text("Xác nhận"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      [bool isDisabled = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        enabled: !isDisabled,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
      ),
    );
  }

// Vùng chọn ảnh với giao diện đẹp hơn
  Widget buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
                  SizedBox(height: 8),
                  Text("Chọn ảnh CCCD",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_selectedImage!,
                    fit: BoxFit.cover, width: double.infinity),
              ),
      ),
    );
  }

  Widget buildDatePickerField(String label, TextEditingController controller,
      [bool isDisabled = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        enabled: !isDisabled, // Vô hiệu hóa nếu isDisabled = true
        onTap: isDisabled ? null : () => _selectDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdownField(String label, List<Map<String, String>> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item['id'],
            child: Text(item['name']!),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Giới tính"),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text("Nam"),
                value: "NAM",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text("Nữ"),
                value: "NỮ",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
