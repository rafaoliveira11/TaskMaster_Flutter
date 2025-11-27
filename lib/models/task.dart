import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;

  final DateTime? alertDate;
  final DateTime? dueDate;
  final String notes;
  final String repeatOption;

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

  bool get hasNotification => alertDate != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'alertDate': alertDate?.toIso8601String(), 
    'dueDate': dueDate?.toIso8601String(),
    'notes': notes,
    'repeatOption': repeatOption,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['id'] as String,
      json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      notes: json['notes'] as String,
      repeatOption: json['repeatOption'] as String,
      alertDate: json['alertDate'] != null ? DateTime.parse(json['alertDate'] as String) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
    );
  }
}