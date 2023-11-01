// event_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class EventEvent {}

class FetchEventListEvent extends EventEvent {}

// States
abstract class EventState {}

class EventInitialState extends EventState {}

class EventLoadingState extends EventState {}

class EventLoadedState extends EventState {
  final List events;

  EventLoadedState(this.events);
}

class EventErrorState extends EventState {
  final String error;

  EventErrorState(this.error);
}



// BLoC
class EventBloc extends Bloc<EventEvent, EventState> {
  final String apiUrl = 'https://gathrr.radarsofttech.in:5050/dummy/event-list';

  EventBloc() : super(EventInitialState());

  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {
    if (event is FetchEventListEvent) {
      yield EventLoadingState();

      try {
        final response = await http.get(Uri.parse(apiUrl));

        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          late var data = json.decode(response.body);
          yield EventLoadedState(data['data'] as List);
        } else {
          yield EventErrorState('Failed to fetch events');
        }
      } catch (e) {
        yield EventErrorState('Network error $e');
      }
    }
  }
}
