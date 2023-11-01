import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:telephony/telephony.dart';

import '../blocs/verifyOtp_bloc.dart';


class OtpPhoneWidget extends StatefulWidget {
  final mobileno;
  OtpPhoneWidget({this.mobileno});

  @override
  _OtpPhoneWidgetState createState() => _OtpPhoneWidgetState();
}

class _OtpPhoneWidgetState extends State<OtpPhoneWidget> {

  String otp = '';
  Telephony telephony = Telephony.instance;
  OtpFieldController otpbox = OtpFieldController();

  @override
  void initState() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        String sms = message.body.toString();
        if (message.body!.contains('Your OTP for Gathrr login is')) {

          String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
          otpbox.set(otpcode.split(""));
          setState(() {
            otp=otpcode;
          });
        } else {
          print("error");
        }
      },
      listenInBackground: false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final VerifyOtpBloc verifyotpBloc = BlocProvider.of<VerifyOtpBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(''),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 50),
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: MediaQuery.of(context).size.width*0.7,
                    fit: BoxFit.fill,
                  ),
                ),
                Text("Check your message box we sent you the 4 digit verification code!",
                    style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.center,),
                SizedBox(height: 30,),

                OTPTextField(
                  outlineBorderRadius: 5,
                  controller: otpbox,
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceEvenly,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    otp = pin;

                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  width:MediaQuery.of(context).size.width*0.95,
                  child: ElevatedButton(
                    onPressed: () {
                      print("##########################333");
                      print(widget.mobileno);
                      print(otp);
                      verifyotpBloc.add(OtpVerificationEvent(widget.mobileno,otp,context));
                    },
                    child: Text('Verify'),
                  ),
                ),
                SizedBox(height: 30,),
                RichText(
                  text: TextSpan(
                      text: "Did't receive it? ",
                      style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 13),
                      children: [
                        TextSpan(
                            text: " Tap to resend",
                            style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500,fontSize: 13)
                        )
                      ]
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
