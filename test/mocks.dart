import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pbi_luarsekolah/repository/notification_repository.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
  MockSpec<FirebaseDatabase>(),
  MockSpec<DatabaseReference>(),
  MockSpec<SharedPreferences>(),
  MockSpec<NavigatorObserver>(),
  MockSpec<NotificationRepository>(),
])
void main() {}