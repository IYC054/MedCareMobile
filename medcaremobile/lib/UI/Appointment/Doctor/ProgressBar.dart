import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;

  const ProgressBar({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStepIcon(Icons.person, currentStep >= 1),
            _buildStepDivider(),
            _buildStepIcon(Icons.medical_services, currentStep >= 2),
            _buildStepDivider(),
            _buildStepIcon(Icons.list_alt, currentStep >= 3),
            _buildStepDivider(),
            _buildStepIcon(Icons.wallet, currentStep >= 4),
            _buildStepDivider(),
            _buildStepIcon(Icons.receipt, currentStep >= 5),
          ],
        ),
        SizedBox(height: 15,),
        Divider(thickness: 2, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildStepIcon(IconData icon, bool isActive) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: isActive ? Colors.blue : Colors.grey[200],
      child: Icon(icon, color: isActive ? Colors.white : Colors.grey),
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}
