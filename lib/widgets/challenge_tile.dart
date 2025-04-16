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
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              challenge?.isCompleted == true
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.primaryContainer,
              challenge?.isCompleted == true
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (challenge?.isCompleted == true)
              Positioned(
                top: -10,
                right: -10,
                child: Transform.rotate(
                  angle: 0.4,
                  child: Icon(
                    Icons.check_circle,
                    size: 40,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      challenge?.title ?? 'Tap to add challenge',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (challenge?.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        challenge!.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else if (challenge == null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Long press to complete',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
