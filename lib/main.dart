import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/challenge.dart';
import 'models/friend.dart';
import 'providers/challenge_provider.dart';
import 'screens/bingo_board_screen.dart';
import 'screens/social_feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(ChallengeAdapter());
  Hive.registerAdapter(FriendAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChallengeProvider()..init(),
      child: MaterialApp(
        title: 'Bingo Challenge',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
            surface: const Color(0xFF1C1B1F),
            background: const Color(0xFF1C1B1F),
            primaryContainer: const Color(0xFF4F378B),
            secondaryContainer: const Color(0xFF3A3A3A),
            tertiaryContainer: const Color(0xFF006C51),
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2D2D2D)),
          cardTheme: CardTheme(
            color: const Color(0xFF2D2D2D),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [BingoBoardScreen(), SocialFeedScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_4x4), label: 'Board'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Social'),
        ],
      ),
    );
  }
}
