import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/challenge.dart';
import 'models/friend.dart';
import 'providers/challenge_provider.dart';
import 'screens/bingo_board_screen.dart';
import 'screens/social_feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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
        title: 'Capades',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(
            background: Color(0xFF121212),
            surface: Color(0xFF1E1E1E),
            primary: Color(0xFF9C27B0),
            secondary: Color(0xFF673AB7),
            tertiary: Color(0xFF009688),
            onBackground: Colors.white,
            onSurface: Colors.white,
            onPrimary: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF1E1E1E),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFF1A1A1A),
            indicatorColor: Color(0xFF9C27B0),
            labelTextStyle: MaterialStatePropertyAll(
              TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
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

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  final List<Widget> _screens = const [BingoBoardScreen(), SocialFeedScreen()];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });

            // Add a little animation
            if (index == 0) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.grid_4x4,
                color: _selectedIndex == 0 ? Colors.white : Colors.white60,
              ),
              label: 'Board',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.groups_rounded,
                color: _selectedIndex == 1 ? Colors.white : Colors.white60,
              ),
              label: 'Social',
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
      ),
    );
  }
}
