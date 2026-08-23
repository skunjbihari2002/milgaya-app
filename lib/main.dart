import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:milgaya/features/home/home_screen.dart';
import 'package:milgaya/features/auth/login_screen.dart';
import 'package:milgaya/features/lost/lost_screen.dart';
import 'package:milgaya/features/found/found_screen.dart';
import 'package:milgaya/features/admin/admin_dashboard.dart';
import 'package:milgaya/features/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Firebase once configured
  // await Firebase.initializeApp();
  runApp(const ProviderScope(child: MilGayaApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/lost',
        builder: (context, state) => const LostScreen(),
      ),
      GoRoute(
        path: '/found',
        builder: (context, state) => const FoundScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
});

class MilGayaApp extends ConsumerWidget {
  const MilGayaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'MilGaya - Lost & Found',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E35B1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
