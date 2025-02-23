import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseProfile.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/ProvinceApi.dart';
import 'package:medcaremobile/services/PatientInformation.dart';

class CreatePatientInformation extends StatefulWidget {
  const CreatePatientInformation({super.key, required this.isVIP});

  final bool isVIP;
  @override
  _CreatePatientInformationState createState() =>
      _CreatePatientInformationState();
}

class _CreatePatientInformationState extends State<CreatePatientInformation> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ethnicityController = TextEditingController();
  TextEditingController bhytController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? gender = "Nam";
  String? selectedProvinceId;
  String? selectedDistrictId;
  String? selectedWardId;
  String? selectedEthnicity;
  String? selectedJob;
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
                  buildTextField("Tên", nameController),
                  buildDatePickerField("Ngày sinh", birthDateController),
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
                  buildTextField("Căn cước công dân", bhytController),
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
                        // Gọi validate() để hiển thị lỗi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Vui lòng điền đầy đủ thông tin!')),
                        );
                        return;
                      }

                      // Nếu validate thành công, tiếp tục xử lý
                      String formattedAddress =
                          "${getProvinceName(selectedProvinceId ?? '')} "
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
                              builder: (context) =>
                                  ChooseProfile(isVIP: widget.isVIP),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi khi tạo hồ sơ!')),
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

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
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

  Widget buildDatePickerField(String label, TextEditingController controller) {
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
        onTap: () => _selectDate(context),
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
                value: "Nam",
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
                value: "Nữ",
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
