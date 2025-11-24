import 'package:flutter/material.dart';
import 'package:taskmaster/models/task.dart'; 
import 'package:taskmaster/screens/welcome_screen.dart'; 
import 'package:taskmaster/screens/login_screen.dart'; 
import 'package:taskmaster/screens/register_screen.dart'; 
import 'package:taskmaster/screens/home_screen.dart'; 
import 'package:taskmaster/screens/task_form_screen.dart';

void main() {
  runApp(const TaskMasterApp());
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF7C4DFF),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
      ),
      initialRoute: '/welcome', 
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(), 
        '/task_form': (context) => const TaskFormScreen(), 
      },
    );
  }
}