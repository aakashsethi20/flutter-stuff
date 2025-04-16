import 'package:hive_flutter/hive_flutter.dart';

part 'friend.g.dart';

@HiveType(typeId: 0)
class Friend {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int progress;

  Friend({required this.id, required this.name, required this.progress});
}
