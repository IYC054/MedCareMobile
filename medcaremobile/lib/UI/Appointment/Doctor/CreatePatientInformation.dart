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

  String? gender;
  String? selectedProvinceId;
  String? selectedDistrictId;
  String? selectedWardId;

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProgressBar(currentStep: 1),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  buildTextField("Tên", nameController),
                  buildDatePickerField("Ngày sinh", birthDateController),
                  buildTextField("Số điện thoại", phoneController),
                  buildGenderField(),
                  buildTextField("Nghề nghiệp", jobController),
                  buildTextField("Email", emailController),
                  buildTextField("Dân tộc", ethnicityController),
                  buildTextField("Căn cước công dân", bhytController),

                  // Dropdown chọn Tỉnh/Thành
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

                  // Dropdown chọn Quận/Huyện
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

                  // Dropdown chọn Phường/Xã
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
                      String formattedAddress =
                          "${getProvinceName(selectedProvinceId ?? '')} "
                          "${getDistrictName(selectedDistrictId ?? '')} "
                          "${getWardName(selectedWardId ?? '')} "
                          "${addressController.text}";
                      print("Tên: ${nameController.text}");
                      print("Ngày sinh: ${birthDateController.text}");
                      print("Số điện thoại: ${phoneController.text}");
                      print("Giới tính: ${gender ?? ""}");
                      print("Nghề nghiệp: ${jobController.text}");
                      print("Email: ${emailController.text}");
                      print("Dân tộc: ${ethnicityController.text}");
                      print("BHYT: ${bhytController.text}");
                      print(
                          "Tỉnh/Thành: ${getProvinceName(selectedProvinceId)}");
                      print(
                          "Quận/Huyện: ${getDistrictName(selectedDistrictId)}");
                      print("Phường/Xã: ${getWardName(selectedWardId)}");
                      print("Địa chỉ chi tiết: ${addressController.text}");
                      print("Địa chỉ hoàn chỉnh: $formattedAddress");

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
                      print("Đã nhấn vao submit");
                      if (result > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tạo hồ sơ thành công!')),
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseProfile(isVIP: widget.isVIP),));
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
            ),
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
          if (value == null) {
            return 'Vui lòng chọn $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildGenderField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Giới tính", style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Radio(
                value: "Nam",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                },
              ),
              Text("Nam"),
              SizedBox(width: 20),
              Radio(
                value: "Nữ",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                },
              ),
              Text("Nữ"),
            ],
          ),
        ],
      ),
    );
  }
}
