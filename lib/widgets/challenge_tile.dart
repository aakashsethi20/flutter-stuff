import 'package:flutter/material.dart';
import '../models/challenge.dart';

class ChallengeTile extends StatelessWidget {
  final int index;
  final Challenge? challenge;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ChallengeTile({
    super.key,
    required this.index,
    this.challenge,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = challenge?.isCompleted == true;
    final bool isEmpty = challenge == null;

    // Define a list of gradient pairs for the tiles
    final List<List<Color>> gradientPairs = [
      [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)], // Purple
      [const Color(0xFF673AB7), const Color(0xFF512DA8)], // Deep Purple
      [const Color(0xFF3F51B5), const Color(0xFF303F9F)], // Indigo
      [const Color(0xFF2196F3), const Color(0xFF1976D2)], // Blue
      [const Color(0xFF009688), const Color(0xFF00796B)], // Teal
    ];

    // Use modulo to cycle through the colors
    final int colorIndex = index % gradientPairs.length;

    // Colors for the tile
    final List<Color> tileGradient =
        isCompleted
            ? [
              const Color(0xFF388E3C),
              const Color(0xFF2E7D32),
            ] // Green for completed
            : gradientPairs[colorIndex];

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isEmpty
                    ? [Colors.grey.shade900, Colors.grey.shade800]
                    : tileGradient,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  isCompleted
                      ? Colors.green.withOpacity(0.3)
                      : isEmpty
                      ? Colors.black.withOpacity(0.2)
                      : tileGradient[0].withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color:
                isCompleted
                    ? Colors.green.withOpacity(0.5)
                    : isEmpty
                    ? Colors.grey.shade700.withOpacity(0.3)
                    : tileGradient[0].withOpacity(0.5),
            width: isCompleted ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            if (isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  challenge?.title ?? 'Tap',
                  style: TextStyle(
                    color: isEmpty ? Colors.grey.shade500 : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    shadows:
                        isEmpty
                            ? []
                            : [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 1),
                              ),
                            ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
