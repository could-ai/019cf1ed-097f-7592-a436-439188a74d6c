import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/student_directory_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/test_management_screen.dart';
import 'models/student.dart';
import 'providers/student_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Academy Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF8BBD9), // Soft pink
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF8BBD9),
          secondary: Color(0xFFA5D6A7), // Sage green
          surface: Color(0xFFFFF8E1), // Cream
          background: Color(0xFFFFF8E1),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: CardTheme(
          color: Colors.white.withOpacity(0.9),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF8BBD9),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(child: DashboardScreen()),
        '/students': (context) => const MainLayout(child: StudentDirectoryScreen()),
        '/attendance': (context) => const MainLayout(child: AttendanceScreen()),
        '/tests': (context) => const MainLayout(child: TestManagementScreen()),
      },
    );
  }
}

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const StudentDirectoryScreen(),
    const AttendanceScreen(),
    const TestManagementScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Student Directory',
    'Attendance Tracker',
    'Test Management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFFF8BBD9),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFFFF8E1),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8BBD9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.local_florist, size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      'Bloom Academy',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Portal',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(0, Icons.dashboard, 'Dashboard'),
              _buildDrawerItem(1, Icons.people, 'Student Directory'),
              _buildDrawerItem(2, Icons.check_circle, 'Attendance Tracker'),
              _buildDrawerItem(3, Icons.assignment, 'Test Management'),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFA5D6A7)),
      title: Text(title, style: GoogleFonts.poppins()),
      selected: _selectedIndex == index,
      selectedTileColor: const Color(0xFFF8BBD9).withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}
