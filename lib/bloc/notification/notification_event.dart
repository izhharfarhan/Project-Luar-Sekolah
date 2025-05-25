import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationReceived extends NotificationEvent {
  final RemoteMessage message;

  const NotificationReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationOpened extends NotificationEvent {
  final RemoteMessage message;

  const NotificationOpened(this.message);

  @override
  List<Object?> get props => [message];
}
