import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:taskmaster/models/task.dart'; 

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


    final backgroundColor = const Color(0xFF6200EA).withOpacity(task.isCompleted ? 0.2 : 0.1);
    
    final checkColor = task.isCompleted ? const Color(0xFF7C4DFF) : Colors.white54;
    final checkIcon = task.isCompleted ? Icons.check_circle : Icons.circle_outlined;

    return GestureDetector(
      onTap: onToggle, 
      onLongPress: onEdit, 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: checkColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(checkIcon, color: checkColor, size: 28),
            const SizedBox(width: 15),
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
            
            if (task.hasNotification)
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(Icons.notifications_active, color: Colors.yellow, size: 20),
              ),
            
            if (!task.isCompleted) 
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _handleLogout(BuildContext context) {
    Navigator.pop(context); 
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/welcome', 
      (Route<dynamic> route) => false, 
    );
  }

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
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 15, left: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
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

          _buildDrawerItem(
            icon: Icons.person_add_alt_1,
            title: 'ADICIONAR PERFIL',
            onTap: () {
              Navigator.pop(context); 
              print('Navegar para Adicionar Perfil');
            },
            color: Colors.white,
          ),
          
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'CONFIGURAÇÕES',
            onTap: () {
              Navigator.pop(context); 
              print('Navegar para Configurações');
            },
            color: Colors.white,
          ),

          const Spacer(),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: _buildDrawerItem(
              icon: Icons.arrow_back,
              title: 'SAIR',
              onTap: () => _handleLogout(context), 
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30), 
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Task> tasks = [];
  bool _isLoading = true; 

  static final List<Task> _defaultTasks = [
    Task('t1', 'Comprar sabão em pó', alertDate: DateTime.now().add(const Duration(days: 1))),
    Task('t2', 'Passar aspirador da casa', isCompleted: true, dueDate: DateTime.now()),
    Task('t3', 'Ligar para o professor', notes: 'Perguntar sobre a prova.'),
    Task('t4', 'Finalizar o projeto Flutter', isCompleted: false),
    Task('t5', 'Fazer mercado da semana'),
  ];
  
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
      setState(() {
        tasks = _defaultTasks;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() async {
    final List<Map<String, dynamic>> tasksMapList = tasks.map((task) => task.toJson()).toList();
    final String tasksString = jsonEncode(tasksMapList); 
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('taskList', tasksString);
  }

  @override
  void initState() {
    super.initState();
    _loadTasks(); 
  }
  
  void _toggleTaskCompletion(int index) {
    final currentTask = tasks[index];

    setState(() {
    });
    _saveTasks(); 
  }
  
  void _deleteTask(String taskId) {
    setState(() {
      tasks.removeWhere((task) => task.id == taskId);
    });
    _saveTasks(); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa excluída!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
  void _navigateToAddOrEditTask({int? taskIndex}) async {
    final isEditing = taskIndex != null;
    final Task? taskToEdit = isEditing ? tasks[taskIndex!] : null;
    
    final result = await Navigator.pushNamed(
      context, 
      '/task_form', 
      arguments: taskToEdit, 
    );
    
    if (result != null && result is Task) {
      setState(() {
        if (isEditing) {
          final index = tasks.indexWhere((t) => t.id == result.id);
          if (index != -1) {
            tasks[index] = result;
          }
        } else {
          tasks.insert(0, result);
        }
      });
      _saveTasks(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (contextScaffold) => Scaffold(
        key: _scaffoldKey,
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
                  _buildHeader(contextScaffold), 
                  
                  const SizedBox(height: 20),
                  _buildFilters(),
                  const SizedBox(height: 30),
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
                  Expanded(
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
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Row(
            children: [
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
