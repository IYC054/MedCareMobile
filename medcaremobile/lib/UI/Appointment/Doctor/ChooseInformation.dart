import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChoosePaymentScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';

class Chooseinformation extends StatefulWidget {
  const Chooseinformation(
      {super.key,
      required this.specialtyname,
      required this.exminationdate,
      required this.clinicdate,
      required this.profileId,
      this.selectedDoctorId,
      this.selectedSpecialtyId,
      this.selectedWorkTimeId,
      this.patientName,
      this.selectDate,
      this.selectTime,
      this.Doctorname,
      this.selectedSpecialtyName, this.isVIP, this.startTime, this.endTime});
  final String specialtyname;
  final DateTime exminationdate;
  final String clinicdate;
  final bool? isVIP;
  final String? Doctorname;
  final String? selectedSpecialtyName;
  final int profileId;
  final int? selectedDoctorId;
  final int? selectedSpecialtyId;
  final int? selectedWorkTimeId;
  final String? patientName;
  final DateTime? selectDate;
  final String? selectTime;
  final String? startTime;
  final String? endTime;
  @override
  State<StatefulWidget> createState() => ChooseinformationState();
}

class ChooseinformationState extends State<Chooseinformation> {
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xác nhận thông tin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(currentStep: 3),
            const SizedBox(height: 24),
            Text(
              'Thông tin đặt khám',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Chuyên khoa:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.specialtyname,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ngày khám:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(formatDate(widget.exminationdate),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Giờ khám:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Flexible(
                          child: Text(
                            widget.clinicdate,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phí khám:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('150.000đ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('BHYT:',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 16)),
                    //     Text('Không',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 16)),
                    //   ],
                    // ),
                    // SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('BLVP:',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 16)),
                    //     Text('Không',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 16)),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng phí:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  widget.isVIP! ? '300.000 đ': '150.000 đ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity, // Full-width button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChoosePaymentScreen(
                              specialtyname: widget.specialtyname,
                              profileId: widget.profileId,
                              patientName: widget.patientName,
                              selectedDoctorId: widget.selectedDoctorId,
                              selectedSpecialtyId: widget.selectedSpecialtyId,
                              selectedWorkTimeId: widget.selectedWorkTimeId,
                              selectDate: widget.selectDate,
                              selectTime: widget.selectTime,
                              Doctorname: widget.Doctorname,
                              isVIP: widget.isVIP,
                              startTime: widget.startTime,
                              endTime: widget.endTime,
                            )),
                  );
                },
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, bool isActive) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: isActive ? Colors.white : Colors.grey),
    );
  }

  Widget _buildStepDivider() {
    return Container(
      height: 2,
      width: 24,
      color: Colors.grey[300],
    );
  }
}
