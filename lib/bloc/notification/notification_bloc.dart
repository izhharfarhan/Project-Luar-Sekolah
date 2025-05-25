import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationReceived>((event, emit) {
      emit(NotificationReceivedState(event.message));
    });

    on<NotificationOpened>((event, emit) {
      emit(NotificationOpenedState(event.message));
    });
  }
}
