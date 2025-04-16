import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/challenge.dart';

class ChallengeProvider with ChangeNotifier {
  List<Challenge> _challenges = [];
  Box<Challenge>? _challengesBox;
  bool _isInitialized = false;

  List<Challenge> get challenges => List.unmodifiable(_challenges);
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      if (!_isInitialized) {
        _challengesBox = await Hive.openBox<Challenge>('challenges');
        _challenges = _challengesBox?.values.toList() ?? [];
        _isInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error initializing challenges: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> addChallenge(Challenge challenge, [int? position]) async {
    try {
      if (!_isInitialized) await init();

      if (position != null && position >= 0 && position < 9) {
        // Remove existing challenge at position if any
        final existingChallenges = _challengesBox?.values.toList() ?? [];
        if (position < existingChallenges.length) {
          await _challengesBox?.delete(existingChallenges[position].id);
        }
      }

      await _challengesBox?.put(challenge.id, challenge);
      _challenges = _challengesBox?.values.toList() ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding challenge: $e');
      rethrow;
    }
  }

  Future<void> removeChallenge(String id) async {
    try {
      if (!_isInitialized) await init();

      await _challengesBox?.delete(id);
      _challenges = _challengesBox?.values.toList() ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing challenge: $e');
      rethrow;
    }
  }

  Future<void> toggleChallenge(String id) async {
    try {
      if (!_isInitialized) await init();

      final challenge = _challenges.firstWhere((c) => c.id == id);
      final updatedChallenge = Challenge(
        id: challenge.id,
        title: challenge.title,
        description: challenge.description,
        isCompleted: !challenge.isCompleted,
      );

      await _challengesBox?.put(id, updatedChallenge);
      _challenges = _challengesBox?.values.toList() ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling challenge: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _challengesBox?.close();
    super.dispose();
  }
}
