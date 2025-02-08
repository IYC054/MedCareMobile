import 'package:flutter/material.dart';

class InputField extends StatefulWidget{
  final TextEditingController emailController;

  const InputField({
    super.key,
    required this.emailController,
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

  void verifyOtp() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      successMessage = '';
    });

    String otp = otpControllers.map((controller) => controller.text).join();
    print("OTP nhập: $otp");
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
                height: 50,
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
