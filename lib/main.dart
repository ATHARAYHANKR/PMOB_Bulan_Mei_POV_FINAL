import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/riwayat_model.dart';
import 'models/user_model.dart';
import 'services/tracking_provider.dart';
import 'services/notification_service.dart';
import 'services/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RiwayatPengirimanAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<RiwayatPengiriman>('riwayat');
  
  // Initialize dummy data untuk demo
  await _initializeDummyData();
  
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TrackingProvider(),
        ),
      ],
      child: const TracklyApp(),
    ),
  );
}

/// Initialize dummy data untuk demo (dipanggil sekali saat first launch)
Future<void> _initializeDummyData() async {
  final provider = TrackingProvider();
  await provider.initializeDummyData();
}

class TracklyApp extends StatelessWidget {
  const TracklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C3317),
          primary: const Color(0xFF5C3317),
          secondary: const Color(0xFFA0673A),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const _RootScreen(),
      routes: {
        '/home': (_) => const MainScreen(),
        '/login': (_) => const LoginScreen(),
      },
    );
  }
}

class _RootScreen extends StatefulWidget {
  const _RootScreen();

  @override
  State<_RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<_RootScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.state == AuthState.initial) {
          return const SplashScreen();
        }
        
        if (authProvider.isAuthenticated) {
          return const MainScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}
