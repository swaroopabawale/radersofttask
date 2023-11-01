// otp_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:task/screens/OtpVerification.dart';

// Events
abstract class OtpEvent {}

class SendOtpEvent extends OtpEvent {
  final String mobileNumber;

  final BuildContext context;

  SendOtpEvent(this.mobileNumber, this.context);
}

// States
abstract class OtpState {}

class OtpInitialState extends OtpState {}

class OtpLoadingState extends OtpState {}

class OtpSentState extends OtpState {}

class OtpErrorState extends OtpState {
  final String error;

  OtpErrorState(this.error);
}

// BLoC
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final String apiUrl = 'https://gathrr.radarsofttech.in:5050/dummy/send-otp';

  OtpBloc() : super(OtpInitialState());

  @override
  Stream<OtpState> mapEventToState(OtpEvent event) async* {
    if (event is SendOtpEvent) {
      yield OtpLoadingState();
      print(event.mobileNumber);
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {'phone': event.mobileNumber},
        );

        print(response.statusCode);
        if (response.statusCode == 200) {
          yield OtpSentState();
          Fluttertoast.showToast(msg: "OTP Send Successfully",toastLength: Toast.LENGTH_SHORT);
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => OtpPhoneWidget(mobileno:event.mobileNumber),
            ),
          );
          // Navigate to the OTP verification page on success
        } else {
          yield OtpErrorState('Failed to send OTP');
        }
      } catch (e) {
        yield OtpErrorState('Network error');
      }
    }
  }
}
