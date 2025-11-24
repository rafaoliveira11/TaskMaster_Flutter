// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:taskmaster/models/task.dart'; 

// --- Componente: Cartão de Tarefa (TaskCard) ---
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit; 

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Cor de fundo do cartão, levemente transparente e roxa
    final backgroundColor = const Color(0xFF6200EA).withOpacity(task.isCompleted ? 0.2 : 0.1);
    
    // Cor e ícone do checkbox
    final checkColor = task.isCompleted ? const Color(0xFF7C4DFF) : Colors.white54;
    final checkIcon = task.isCompleted ? Icons.check_circle : Icons.circle_outlined;

    return GestureDetector(
      onTap: onToggle, // Alterna o estado ao tocar em qualquer lugar do card
      onLongPress: onEdit, // Adiciona uma função de Edição no toque longo (opcional)
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: checkColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Ícone de Status (Checkbox)
            Icon(checkIcon, color: checkColor, size: 28),
            const SizedBox(width: 15),
            
            // Título da Tarefa
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: Colors.white70,
                  fontStyle: task.isCompleted ? FontStyle.italic : FontStyle.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Ícone de Notificação (Opcional - agora usa o getter hasNotification)
            if (task.hasNotification)
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(Icons.notifications_active, color: Colors.yellow, size: 20),
              ),
            
            // Ícone de Edição (Adicionado para visualização)
            if (!task.isCompleted) // Mostra o ícone de edição se não estiver concluída
              GestureDetector(
                onTap: onEdit,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.edit, color: Colors.white54, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Componente: Gaveta de Perfil (AppDrawer) ---
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // Função para simular o Logout
  void _handleLogout(BuildContext context) {
    Navigator.pop(context); 
    // Volta para a rota de Boas-Vindas
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/welcome', // Rota para a WelcomeScreen, conforme definido em main.dart
      (Route<dynamic> route) => false, 
    );
  }

  // Componente reutilizável para itens da Gaveta
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.95), 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: <Widget>[
          // --- 1. Área de Perfil no Topo ---
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 15, left: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              // Linha divisória sutil
              border: Border(bottom: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: const Text(
              'PERFIL DO USUÁRIO',
              style: TextStyle(
                color: Colors.white70, 
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // --- 2. Opções Principais ---
          _buildDrawerItem(
            icon: Icons.person_add_alt_1,
            title: 'ADICIONar PERFIL',
            onTap: () {
              Navigator.pop(context); 
              // TODO: Implementar tela de Adicionar Perfil
              print('Navegar para Adicionar Perfil');
            },
            color: Colors.white,
          ),
          
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'CONFIGURAÇÕES',
            onTap: () {
              Navigator.pop(context); 
              // TODO: Implementar tela de Configurações
              print('Navegar para Configurações');
            },
            color: Colors.white,
          ),

          // --- 3. Espaço Flexível ---
          const Spacer(),

          // --- 4. Opção Sair (Logout) ---
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              // Linha divisória sutil acima do SAIR
              border: Border(top: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: _buildDrawerItem(
              icon: Icons.arrow_back,
              title: 'SAIR',
              onTap: () => _handleLogout(context), 
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30), // Espaçamento inferior
        ],
      ),
    );
  }
}


// --- Tela Principal (HomeScreen) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. ESTADO: Lista de tarefas (Inicialmente vazia, será preenchida pelo _loadTasks)
  List<Task> tasks = [];
  bool _isLoading = true; // Novo estado para controlar o carregamento

  // Lista inicial de tarefas para preencher a primeira vez que o app rodar
  static final List<Task> _defaultTasks = [
    Task('t1', 'Comprar sabão em pó', alertDate: DateTime.now().add(const Duration(days: 1))),
    Task('t2', 'Passar aspirador da casa', isCompleted: true, dueDate: DateTime.now()),
    Task('t3', 'Ligar para o professor', notes: 'Perguntar sobre a prova.'),
    Task('t4', 'Finalizar o projeto Flutter', isCompleted: false),
    Task('t5', 'Fazer mercado da semana'),
  ];
  
  // --- FUNÇÕES DE PERSISTÊNCIA ---

  // Carrega as tarefas salvas localmente
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('taskList');
    
    if (tasksString != null && tasksString.isNotEmpty) {
      // 1. Converte a string JSON de volta para List<Map>
      final List<dynamic> decodedList = jsonDecode(tasksString);
      // 2. Converte List<Map> em List<Task> usando Task.fromJson
      final List<Task> loadedTasks = decodedList.map((item) => Task.fromJson(item as Map<String, dynamic>)).toList();
      
      setState(() {
        tasks = loadedTasks;
      });
    } else {
      // Se não houver dados, usa as tarefas padrão
      setState(() {
        tasks = _defaultTasks;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Salva a lista de tarefas localmente
  Future<void> _saveTasks() async {
    // 1. Converte List<Task> para List<Map> usando task.toJson()
    final List<Map<String, dynamic>> tasksMapList = tasks.map((task) => task.toJson()).toList();
    // 2. Codifica List<Map> para String JSON
    final String tasksString = jsonEncode(tasksMapList);
    
    final prefs = await SharedPreferences.getInstance();
    // 3. Salva a string no SharedPreferences
    await prefs.setString('taskList', tasksString);
  }

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Carrega as tarefas ao iniciar a tela
  }
  
  // --- FUNÇÕES DE MUTAÇÃO ---

  // 2. Método para alternar o estado de conclusão de uma tarefa
  // CORREÇÃO: Usa copyWith para criar uma nova Task (imutabilidade)
  void _toggleTaskCompletion(int index) {
    final currentTask = tasks[index];

    setState(() {
      // Cria uma nova Task, invertendo apenas o estado 'isCompleted'
      tasks[index] = currentTask.copyWith(
        isCompleted: !currentTask.isCompleted,
      );
    });
    _saveTasks(); // Salva a alteração
  }
  
  // 3. Método para deletar uma tarefa
  void _deleteTask(String taskId) {
    setState(() {
      tasks.removeWhere((task) => task.id == taskId);
    });
    _saveTasks(); // Salva a exclusão
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa excluída!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 4. Método para navegar para o formulário de criação/edição e esperar pelo resultado
  void _navigateToAddOrEditTask({int? taskIndex}) async {
    final isEditing = taskIndex != null;
    final Task? taskToEdit = isEditing ? tasks[taskIndex!] : null;
    
    final result = await Navigator.pushNamed(
      context, 
      '/task_form', 
      arguments: taskToEdit, 
    );
    
    // Lógica para adicionar/atualizar a tarefa após retornar do formulário
    if (result != null && result is Task) {
      setState(() {
        if (isEditing) {
          // Atualiza a tarefa existente na lista
          final index = tasks.indexWhere((t) => t.id == result.id);
          if (index != -1) {
            tasks[index] = result;
          }
        } else {
          // Adiciona a nova tarefa no topo da lista
          tasks.insert(0, result);
        }
      });
      _saveTasks(); // Salva a adição ou edição
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um Builder para criar um contexto que permita abrir o Drawer
    return Builder(
      builder: (contextScaffold) => Scaffold(
        drawer: const AppDrawer(), 
        
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E1E), 
                Color(0xFF200545), 
                Color(0xFF6200EA), 
              ],
              stops: [0.0, 0.4, 1.0], 
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. Cabeçalho/Top Bar ---
                  _buildHeader(contextScaffold), 
                  
                  const SizedBox(height: 20),

                  // --- 2. Filtros (Mockup do Design) ---
                  _buildFilters(),

                  const SizedBox(height: 30),

                  // --- 3. Título da Lista ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF7C4DFF), width: 1.5)
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'TAREFAS DA SEMANA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- 4. Lista de Tarefas (Listagem Dinâmica com Dismissible) ---
                  Expanded(
                    // Mostra um indicador de carregamento enquanto espera por _loadTasks
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF)))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Dismissible(
                                key: ValueKey(task.id), 
                                direction: DismissDirection.endToStart, 
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
                                ),
                                onDismissed: (direction) {
                                  _deleteTask(task.id); 
                                },
                                child: TaskCard(
                                  task: task,
                                  onToggle: () => _toggleTaskCompletion(index),
                                  onEdit: () => _navigateToAddOrEditTask(taskIndex: index),
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // --- Floating Action Button (Botão de Adicionar) ---
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToAddOrEditTask(), 
          backgroundColor: const Color(0xFF7C4DFF),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  // --- Widgets Auxiliares ---

  // Cabeçalho da tela (inclui o botão que abre o Drawer)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Ícone de Perfil e Título (CHAMA O DRAWER NO TAP)
        GestureDetector(
          onTap: () {
            // Usa o contexto do Builder para abrir o Drawer
            Scaffold.of(context).openDrawer(); 
          },
          child: Row(
            children: [
              // Ícone/Avatar do Usuário
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF7C4DFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 15),
              const Text(
                'PERFIL DO USUÁRIO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),

        // Ícone de Pesquisa
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7C4DFF), width: 1),
          ),
          child: const Icon(Icons.search, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterButton('TAREFAS', isActive: true),
        const SizedBox(width: 10),
        _buildFilterButton(''),
        const SizedBox(width: 10),
        _buildFilterButton(''),
        GestureDetector(
          onTap: () => _navigateToAddOrEditTask(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7C4DFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, {bool isActive = false}) {
    return Expanded(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7C4DFF) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF7C4DFF).withOpacity(isActive ? 1.0 : 0.5), width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}