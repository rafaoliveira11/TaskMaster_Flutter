import 'package:flutter/material.dart';

// Este modelo de dados (Model) representa uma única tarefa
class Task {
  // A classe é imutável, então todas as propriedades, exceto as nullable (que
  // podem mudar implicitamente para null ou vice-versa), são 'final'.
  final String id;
  final String title;
  final bool isCompleted;
  
  // CAMPOS DO FORMULÁRIO
  final DateTime? alertDate;
  final DateTime? dueDate;
  final String notes;
  final String repeatOption;

  // Construtor principal
  Task(
    this.id, 
    this.title, 
    {
      this.isCompleted = false, 
      this.alertDate,
      this.dueDate,
      this.notes = '',
      this.repeatOption = 'Nunca',
    }
  );
  
  // Getter para a notificação
  bool get hasNotification => alertDate != null;

  // --- MÉTODOS DE SERIALIZAÇÃO (PARA SALVAR) ---

  // Converte o objeto Task em um Map (JSON)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    // Converte DateTime para String ISO 8601 (formato padrão de texto)
    'alertDate': alertDate?.toIso8601String(), 
    'dueDate': dueDate?.toIso8601String(),
    'notes': notes,
    'repeatOption': repeatOption,
  };

  // Cria um objeto Task a partir de um Map (JSON)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['id'] as String,
      json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      notes: json['notes'] as String,
      repeatOption: json['repeatOption'] as String,
      // Converte a String de volta para DateTime, se existir
      alertDate: json['alertDate'] != null ? DateTime.parse(json['alertDate'] as String) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
    );
  }
}