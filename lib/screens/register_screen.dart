import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela de cadastro', style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: size.height - AppBar().preferredSize.height),
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF200545),
                Color(0xFF6200EA),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
    
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C4DFF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 50,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  Container(
                    width: size.width * 0.9, 
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF7C4DFF).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CADASTRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 30),

                        _buildModernInput(label: "Email"),
                        
                        const SizedBox(height: 20),

                        _buildModernInput(label: "Senha", isPassword: true),

                        const SizedBox(height: 20),

                        _buildModernInput(label: "Confirmação sua senha", isPassword: true),
                        
                        const SizedBox(height: 20),
                        _buildModernInput(label: "Nome de usuário"),

                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              print("Clicou em FINALIZAR Cadastro");

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6200EA), 
                              side: const BorderSide(color: Color(0xFF7C4DFF), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'FINALIZAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextButton(
                    onPressed: () {
                     
                      Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/login', 
                          (Route<dynamic> route) => false, 
                      );
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInput({required String label, bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF7C4DFF), width: 2),
        ),
        suffixIcon: isPassword
            ? const Icon(Icons.lock_outline, color: Colors.grey)
            : label.contains('Email')
                ? const Icon(Icons.email_outlined, color: Colors.grey)
                : const Icon(Icons.person_outline, color: Colors.grey),
      ),
    );
  }
}
