import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetSpecialtyApi.dart';

class Choosespecialtyscreen extends StatefulWidget {
  const Choosespecialtyscreen({super.key, required this.id});
  final int id;
  @override
  State<StatefulWidget> createState() => ChoosespecialtyscreenState();
}

class ChoosespecialtyscreenState extends State<Choosespecialtyscreen> {
  List<dynamic> specialty = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchspecialty();
  }

  void fetchspecialty() async {
    final fetchedspecialty =
        await Getspecialtyapi.getSpecialtyByDoctorid(widget.id);
    print("specialty: $fetchedspecialty"); // Kiểm tra dữ liệu từ API
    if (fetchedspecialty != null) {
      setState(() {
        specialty = fetchedspecialty;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn chuyên khoa'),
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
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm chuyên khoa...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: specialty.length,
                      itemBuilder: (context, index) {
                        final specialtys = specialty[index];
                        return _buildDoctorCard(
                          context,
                          specialtyid: specialtys['id'],
                          specialty: specialtys['name'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context, {
    required String specialty,
    required int specialtyid,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(specialty,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue)),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {'specialty': specialty, 'specialtyid': specialtyid});
                },
                child: Text('Chọn'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
