import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import '../widgets/challenge_tile.dart';

class BingoBoardScreen extends StatelessWidget {
  const BingoBoardScreen({super.key});

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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Bingo Challenge',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Consumer<ChallengeProvider>(
                builder: (context, provider, child) {
                  final challenges = provider.challenges;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final challenge =
                          index < challenges.length ? challenges[index] : null;
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
                                ? () => provider.toggleChallenge(challenge.id)
                                : null,
                      );
                    },
                  );
                },
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
  late final TextEditingController _descController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.challenge?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.challenge?.description ?? '',
    );
    _isCompleted = widget.challenge?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.challenge != null;

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'Edit Challenge' : 'Add Challenge',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter challenge title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter challenge description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLength: 200,
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Completed'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value;
                });
              },
            ),
            const SizedBox(height: 16),
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
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    if (_titleController.text.isEmpty) return;

                    final challenge = Challenge(
                      id: widget.challenge?.id ?? DateTime.now().toString(),
                      title: _titleController.text.trim(),
                      description: _descController.text.trim(),
                      isCompleted: _isCompleted,
                    );

                    final provider = context.read<ChallengeProvider>();
                    provider.addChallenge(challenge, widget.index);

                    Navigator.of(context).pop();
                  },
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? 'Save' : 'Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
