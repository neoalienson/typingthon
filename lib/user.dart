import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.email,
  });

  final String email;
}

@JsonSerializable()
class HistoryRecord {
  HistoryRecord({
    required this.datetime,
    required this.wpm,
  });

  final DateTime datetime;
  final int wpm;
}

@Collection<User>('users')
@Collection<HistoryRecord>('users/*/history')
final usersRef = UserCollectionReference();
