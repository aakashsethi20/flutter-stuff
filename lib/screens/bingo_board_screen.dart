import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import '../widgets/challenge_tile.dart';

class BingoBoardScreen extends StatefulWidget {
  const BingoBoardScreen({super.key});

  @override
  State<BingoBoardScreen> createState() => _BingoBoardScreenState();
}

class _BingoBoardScreenState extends State<BingoBoardScreen>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  static const int GRID_SIZE = 5; // 5x5 grid
  static const int CHALLENGE_COUNT = 25; // 5x5 = 25 challenges

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      // If already zoomed in, zoom out to initial position
      _resetToInitialPosition();
    } else if (_doubleTapDetails != null) {
      // If at initial position, zoom in centered on the tap location
      _zoomIn(_doubleTapDetails!);
    }
  }

  void _resetToInitialPosition() {
    final Matrix4 initialMatrix = Matrix4.identity();
    _animateMatrix(_transformationController.value, initialMatrix);
  }

  void _zoomIn(TapDownDetails details) {
    final position = details.localPosition;
    // Zoom factor
    const double scale = 2.5;

    final Matrix4 zoomMatrix =
        Matrix4.identity()
          ..translate(-position.dx * (scale - 1), -position.dy * (scale - 1))
          ..scale(scale);

    _animateMatrix(_transformationController.value, zoomMatrix);
  }

  void _animateMatrix(Matrix4 from, Matrix4 to) {
    _animation = Matrix4Tween(begin: from, end: to).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward(from: 0);
  }

  void _showChallengeDialog(
    BuildContext context, {
    Challenge? challenge,
    required int index,
  }) {
    showDialog(
      context: context,
      builder: (context) => ChallengeDialog(challenge: challenge, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CAPADES',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.purple.withOpacity(0.7),
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onDoubleTapDown: _handleDoubleTapDown,
                    onDoubleTap: _handleDoubleTap,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 0.5,
                      maxScale: 4.0,
                      boundaryMargin: const EdgeInsets.all(50),
                      child: Consumer<ChallengeProvider>(
                        builder: (context, provider, child) {
                          final challenges = provider.challenges;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: GRID_SIZE,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                ),
                            itemCount: CHALLENGE_COUNT,
                            itemBuilder: (context, index) {
                              final challenge =
                                  index < challenges.length
                                      ? challenges[index]
                                      : null;
                              return ChallengeTile(
                                index: index,
                                challenge: challenge,
                                onTap:
                                    () => _showChallengeDialog(
                                      context,
                                      challenge: challenge,
                                      index: index,
                                    ),
                                onLongPress:
                                    challenge != null
                                        ? () => provider.toggleChallenge(
                                          challenge.id,
                                        )
                                        : null,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: 'Zoom Out',
                    child: IconButton(
                      onPressed: _resetToInitialPosition,
                      icon: Icon(
                        Icons.zoom_out,
                        color: Colors.white.withOpacity(0.8),
                        size: 32,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Tooltip(
                    message: 'Double-tap to zoom in/out',
                    child: Icon(
                      Icons.touch_app,
                      color: Colors.white.withOpacity(0.8),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeDialog extends StatefulWidget {
  final Challenge? challenge;
  final int index;

  const ChallengeDialog({super.key, this.challenge, required this.index});

  @override
  State<ChallengeDialog> createState() => _ChallengeDialogState();
}

class _ChallengeDialogState extends State<ChallengeDialog> {
  late final TextEditingController _titleController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.challenge?.title ?? '',
    );
    _isCompleted = widget.challenge?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.challenge != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
          border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'EDIT CHALLENGE' : 'NEW CHALLENGE',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey[400]),
                hintText: 'Enter challenge title',
                hintStyle: TextStyle(color: Colors.grey[700]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.purple[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              style: const TextStyle(color: Colors.white),
              maxLength: 50,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text(
                'Completed',
                style: TextStyle(color: Colors.white),
              ),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value;
                });
              },
              activeColor: Colors.green[300],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isEditing)
                  TextButton.icon(
                    onPressed: () {
                      context.read<ChallengeProvider>().removeChallenge(
                        widget.challenge!.id,
                      );
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.delete, color: Colors.red[300]),
                    label: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red[300]),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty) return;

                    final challenge = Challenge(
                      id: widget.challenge?.id ?? DateTime.now().toString(),
                      title: _titleController.text.trim(),
                      description: '', // Description removed
                      isCompleted: _isCompleted,
                    );

                    final provider = context.read<ChallengeProvider>();
                    provider.addChallenge(challenge, widget.index);

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(isEditing ? 'SAVE' : 'ADD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
