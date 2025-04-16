import 'package:hive_flutter/hive_flutter.dart';

part 'challenge.g.dart';

@HiveType(typeId: 1)
class Challenge {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
