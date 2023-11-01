import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/sendOtp_bloc.dart';


class SendOtpScreen extends StatelessWidget {
  TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final OtpBloc otpBloc = BlocProvider.of<OtpBloc>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child:  SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 100),
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: MediaQuery.of(context).size.width*0.7,
                    fit: BoxFit.fill,
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,

                  child: Text("Login to Gathrr",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400),),
                ),


                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Gathrr is the go-to app to attend events network with the people from your industry.",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.7)),),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Phone Number",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                ),


                TextField(
                  controller: mobileNumberController,
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                ),

                Padding(
                  padding:  EdgeInsets.only(top: 20),
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      value: true,
                      onChanged:(value){},
                      title: RichText(
                        text: TextSpan(
                            text: "By Proceeding you agree to our ",
                            style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 13),
                            children: [
                              TextSpan(
                                  text: " Terms and Conditions Privacy Policies",
                                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500,fontSize: 13)
                              )
                            ]
                        ),
                      )
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  width:MediaQuery.of(context).size.width*0.95,
                  child: ElevatedButton(
                    onPressed: () {
                      final mobileNumber = mobileNumberController.text;
                      otpBloc.add(SendOtpEvent(mobileNumber,context));
                    },
                    child: Text('Login'),
                  ),
                ),
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    if (state is OtpLoadingState) {
                      return CircularProgressIndicator();
                    } else if (state is OtpSentState) {
                      // Fluttertoast.showToast(msg: "${state.message}",toastLength: Toast.LENGTH_SHORT);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerification()));
                      return Text("");
                    } else if (state is OtpErrorState) {
                      // Fluttertoast.showToast(msg: "${state.error}",toastLength: Toast.LENGTH_LONG);
                      return Text('Error: ${state.error}');
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}