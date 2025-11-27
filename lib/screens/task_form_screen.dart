import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; 
import 'package:taskmaster/models/task.dart'; 

const uuid = Uuid();

class TaskFormScreen extends StatefulWidget {
  final Task? taskToEdit;
  
  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _alertDate;
  DateTime? _dueDate;
  String _repeatOption = 'Nunca'; 

  late String _taskId;

  @override
  void initState() {
    super.initState();
    
    final Task? task = widget.taskToEdit;
    
    if (task != null) {
      _taskId = task.id; 
      _titleController.text = task.title;
      _notesController.text = task.notes;
      _alertDate = task.alertDate;
      _dueDate = task.dueDate;
      _repeatOption = task.repeatOption;
      
    } else {
      _taskId = uuid.v4();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isAlertDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isAlertDate ? (_alertDate ?? DateTime.now()) : (_dueDate ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7C4DFF), 
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isAlertDate) {
          _alertDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título da tarefa é obrigatório.')),
      );
      return;
    }

    final newTask = Task(
      _taskId, 
      title,
      isCompleted: widget.taskToEdit?.isCompleted ?? false, 
      alertDate: _alertDate,
      dueDate: _dueDate,
      notes: _notesController.text.trim(),
      repeatOption: _repeatOption,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.taskToEdit == null ? 'Tarefa Criada: $title' : 'Tarefa Atualizada: $title')),
    );

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {

    final screenTitle = widget.taskToEdit == null ? 'Adição de nova tarefa' : 'Edição de tarefa';
    
    return Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      screenTitle, 
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: _saveTask,
                      icon: const Icon(Icons.check, color: Color(0xFF7C4DFF), size: 30),
                      tooltip: 'Salvar Tarefa',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05), 
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: const Color(0xFF7C4DFF), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Icon(Icons.check_circle_outline, color: Color(0xFF7C4DFF), size: 28),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: TextFormField(
                                    controller: _titleController,
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    decoration: const InputDecoration(
                                      hintText: 'NOVA TAREFA',
                                      hintStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF7C4DFF), width: 2),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 30),

                            _buildStepButton(),

                            const SizedBox(height: 20),
                            
                            _buildDateField(
                              label: 'Data de aviso',
                              value: _alertDate,
                              onTap: () => _selectDate(context, true),
                              icon: Icons.notifications_none,
                            ),

                            const SizedBox(height: 20),

                            _buildDateField(
                              label: 'Data de conclusão',
                              value: _dueDate,
                              onTap: () => _selectDate(context, false),
                              icon: Icons.calendar_today,
                            ),
                            
                            const SizedBox(height: 20),

                            _buildRepeatDropdown(),
                            
                            const SizedBox(height: 20),


                            _buildNotesField(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, color: Color(0xFF7C4DFF), size: 20),
          const SizedBox(width: 10),
          Text(
            'Adicionar etapa',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final String displayValue = value == null 
        ? 'Nenhuma data selecionada' 
        : '${value.day}/${value.month}/${value.year}';
        
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, color: Colors.white54),
                  const SizedBox(width: 10),
                  // Rótulo
                  Text(
                    '$label: ',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Flexible( 
                    child: Text(
                      displayValue,
                      style: const TextStyle(color: Color(0xFF7C4DFF), fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _repeatOption,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E1E), 
          style: const TextStyle(color: Colors.white, fontSize: 16),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _repeatOption = newValue;
              });
            }
          },
          items: <String>['Nunca', 'Diário', 'Semanal', 'Mensal']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: _notesController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          labelText: 'Notas',
          labelStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        ),
      ),
    );
  }
}