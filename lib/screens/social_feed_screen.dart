import 'package:flutter/material.dart';
import '../models/friend.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary mock data
    final List<Friend> friends = [
      Friend(id: '1', name: 'Alice', progress: 5),
      Friend(id: '2', name: 'Bob', progress: 3),
      Friend(id: '3', name: 'Charlie', progress: 7),
    ];

    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  friend.name[0],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              title: Text(friend.name),
              subtitle: LinearProgressIndicator(
                value: friend.progress / 9,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: Text('${friend.progress}/9'),
            ),
          );
        },
      ),
    );
  }
}
