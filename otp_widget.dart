import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpWidget extends StatefulWidget {
  ///This function returns the current otpcode after
  ///each box is changed
  ///If OTP of a certain lenght is desired, use a conditional
  ///Valuechanged<String> and Function(String) has no difference.
  final ValueChanged<String>? onOTPchanged;
  const OtpWidget({Key? key, this.onOTPchanged}) : super(key: key);

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final int numberOfFields = 5;

  final double fieldSpacing = 10.0;

  final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;

  final TextStyle style =
      GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w300, fontSize: 24.0);

  final BorderRadius? borderRadius = BorderRadius.circular(5.0);

  final List<TextEditingController> listofController = [];
  final List<FocusNode> listOfFocusNode = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfFields; i++) {
      listofController.add(TextEditingController());
      listOfFocusNode.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in listofController) {
      controller.dispose();
    }
    for (FocusNode node in listOfFocusNode) {
      node.dispose();
    }
    super.dispose();
  }

  String returnEnteredCode() {
    return listofController.fold<String>(
        '', (previousValue, element) => previousValue + element.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          for (int item = 0; item < numberOfFields; item++)
            Container(
              margin: item + 1 != numberOfFields
                  ? EdgeInsets.only(right: fieldSpacing)
                  : null,
              width: 50.0,
              height: 56.0,
              decoration: BoxDecoration(
                  borderRadius: borderRadius, border: Border.all()),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 17.0, right: 12.0, top: 15.0),
                child: TextFormField(
                  onTap: () {
                    listofController[item].clear();
                  },
                  onChanged: (value) {
                    if (item + 1 != numberOfFields) {
                      //only change focus when a value is entered.
                      if (value.isNotEmpty) {
                        listOfFocusNode[item + 1].requestFocus();
                      }
                    }
                    widget.onOTPchanged!(returnEnteredCode());
                  },
                  focusNode: listOfFocusNode[item],
                  controller: listofController[item],
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 1,
                  style: style,
                  decoration: const InputDecoration(
                    counter: SizedBox.shrink(),
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
