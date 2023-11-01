// event_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class EventDetailsEvent {}

class FetchEventDetailsListEvent extends EventDetailsEvent {
  final id;
  FetchEventDetailsListEvent(this.id);
}

// States
abstract class EventDetailsState {}

class EventDetailsInitialState extends EventDetailsState {}

class EventDetailsLoadingState extends EventDetailsState {}

class EventDetailsLoadedState extends EventDetailsState {
  final  events;

  EventDetailsLoadedState(this.events);
}

class EventDetailsErrorState extends EventDetailsState {
  final String error;

  EventDetailsErrorState(this.error);
}



// BLoC
class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final String apiUrl = 'https://gathrr.radarsofttech.in:5050/dummy/event-details/';

  EventDetailsBloc() : super(EventDetailsInitialState());

  @override
  Stream<EventDetailsState> mapEventToState(EventDetailsEvent event) async* {
    print("Here");
    if (event is FetchEventDetailsListEvent) {
      yield EventDetailsLoadingState();

      try {
        final response = await http.get(Uri.parse(apiUrl+event.id));

        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          late var data = json.decode(response.body);
          yield EventDetailsLoadedState(data['data']);
        } else {
          yield EventDetailsErrorState('Failed to fetch events');
        }
      } catch (e) {
        yield EventDetailsErrorState('Network error $e');
      }
    }
  }
}
