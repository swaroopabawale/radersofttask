import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:task/blocs/eventdetail_bloc.dart';
import 'package:task/blocs/verifyOtp_bloc.dart';
import 'package:task/screens/sendotpscreen.dart';

import 'blocs/home_bloc.dart';
import 'blocs/sendOtp_bloc.dart';
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OtpBloc>(
          create: (BuildContext context) => OtpBloc(),
        ),
        BlocProvider<VerifyOtpBloc>(
          create: (BuildContext context) => VerifyOtpBloc(),
        ),
        BlocProvider<EventBloc>(create: (BuildContext context)=>EventBloc()),
        BlocProvider<EventDetailsBloc>(create: (BuildContext context)=>EventDetailsBloc()),

      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MultiblocProvider',
      home: SendOtpScreen(),
    );
  }
}

