import 'package:flutter/material.dart';

class InputField extends StatefulWidget{
  final TextEditingController emailController;
  final Function(String) onOtpChanged; // Callback truyền OTP ra ngoài

  const InputField({
    super.key,
    required this.emailController,
    required this.onOtpChanged,
  });


  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField>{
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

  void _updateOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();
    print("OTP nhập: $otp");
    widget.onOtpChanged(otp); // Truyền OTP đến Button
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                width: 40,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: otpControllers[index],
                  focusNode: focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                    }
                    _updateOtp();
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

}
