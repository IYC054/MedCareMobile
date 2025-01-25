import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Inputfield extends StatefulWidget {
  Inputfield({super.key});
  @override
  State<StatefulWidget> createState() => InputfieldState();
}

class InputfieldState extends State<Inputfield> {
  // value gioi tinh
  String? selectedGender;
  DateTime? selectedDate;
  @override
  TextEditingController _datecontroller = new TextEditingController();
  
  Widget build(BuildContext context) {
    Future<void> _selectDate() async {
      DateTime? _picker = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (_picker != null) {
        setState(() {
          selectedDate = _picker;
          // Định dạng lại ngày tháng trước khi hiển thị
          _datecontroller.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
        });
      }
    }

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Email",
                hintText: "Nhập email",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Tên",
                hintText: "Nhập tên",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Số điện thoại",

                hintText: "Nhập số điện thoại",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: DropdownButtonFormField<String>(
            value: selectedGender, // Giá trị được chọn
            onChanged: (String? newValue) {
              setState(() {
                selectedGender = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: "Giới tính",
              hintText: "Chọn giới tính",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            items: <String>['Nam', 'Nữ']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            controller: _datecontroller,
            decoration: InputDecoration(
              labelText: "Ngày sinh",
              filled: true,
              prefixIcon: Icon(Icons.calendar_today),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
            readOnly: true,
            onTap: () => {_selectDate()},
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Mật khẩu",
                hintText: "Nhập mật khẩu",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
