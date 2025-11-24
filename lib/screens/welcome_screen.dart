// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela para ajudar na responsividade
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. O Fundo Degradê (Gradient Background)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E1E), // Preto/Cinza escuro no topo
              Color(0xFF200545), // Roxo escuro transicional
              Color(0xFF6200EA), // Roxo vibrante no final
            ],
            stops: [0.0, 0.6, 1.0], // Controla onde as cores mudam
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2), // Empurra conteúdo um pouco para baixo

              // 2. Título "TASKMASTER"
              const Text(
                'TASKMASTER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontFamily: 'Roboto', 
                ),
              ),

              const SizedBox(height: 40),

              // 3. O Logo (Placeholder moderno)
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF), // Roxo mais claro
                  shape: BoxShape.circle,
                  // CORREÇÃO: O nome do parâmetro deve ser 'boxShadow', não 'boxBoxShadow'
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 100,
                  color: Colors.black54,
                ),
              ),

              const Spacer(flex: 3), // Espaço flexível entre logo e botões

              // 4. Botões de Ação
              
              // Botão LOGIN (Navegação com Rota Nomeada)
              TextButton(
                onPressed: () {
                  // Navega para a tela de Login
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão CADASTRO (Navegação com Rota Nomeada)
              TextButton(
                onPressed: () {
                  // Navega para a tela de Cadastro
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'CADASTRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 50), // Espaço final
            ],
          ),
        ),
      ),
    );
  }
}