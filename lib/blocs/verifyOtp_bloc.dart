// otp_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:task/screens/OtpVerification.dart';
import 'package:task/screens/homescreen.dart';

// Events
abstract class VerifyOtpEvent {}

class OtpVerificationEvent extends VerifyOtpEvent {
  final String mobileNumber;
  final String otp;

  final BuildContext context;

  OtpVerificationEvent(this.mobileNumber,this.otp, this.context);
}

// States
abstract class VerifyOtpState {}

class VerifyOtpInitialState extends VerifyOtpState {}

class VerifyOtpLoadingState extends VerifyOtpState {}

class VerifyOtpSentState extends VerifyOtpState {}

class VerifyOtpErrorState extends VerifyOtpState {
  final String error;

  VerifyOtpErrorState(this.error);
}

// BLoC
class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final String apiUrl = 'https://gathrr.radarsofttech.in:5050/dummy/verify-otp';

  VerifyOtpBloc() : super(VerifyOtpInitialState());

  @override
  Stream<VerifyOtpState> mapEventToState(VerifyOtpEvent event) async* {
    if (event is OtpVerificationEvent) {
      yield VerifyOtpLoadingState();
      print(event.mobileNumber);
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "phone": event.mobileNumber,
            "otp": event.otp
          },
        );

        print(response.statusCode);
        if (response.statusCode == 200) {
          yield VerifyOtpSentState();
          Fluttertoast.showToast(msg: "OTP Verify Successfully",toastLength: Toast.LENGTH_SHORT);
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => Homescreen(),
            ),
          );
          // Navigate to the VerifyOtp verification page on success
        } else {
          yield VerifyOtpErrorState('Failed to  Verify Otp');
        }
      } catch (e) {
        yield VerifyOtpErrorState('Network error');
      }
    }
  }
}
