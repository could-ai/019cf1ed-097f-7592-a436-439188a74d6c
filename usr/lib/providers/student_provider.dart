import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [
    Student(
      id: '1',
      name: 'Alice Johnson',
      fatherName: 'Bob Johnson',
      studentClass: 'Grade 5',
      phone: '123-456-7890',
      feePaid: true,
      attendance: {'2024-01-01': true, '2024-01-02': false},
      testMarks: {'January': 85.0, 'February': 92.0},
    ),
    Student(
      id: '2',
      name: 'Charlie Brown',
      fatherName: 'David Brown',
      studentClass: 'Grade 3',
      phone: '098-765-4321',
      feePaid: false,
      attendance: {'2024-01-01': true},
      testMarks: {'January': 78.0},
    ),
  ];

  List<Student> get students => _students;

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(String id, Student updatedStudent) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void markAttendance(String studentId, String date, bool present) {
    final student = _students.firstWhere((s) => s.id == studentId);
    student.attendance[date] = present;
    notifyListeners();
  }

  void addTestMarks(String studentId, String month, double marks) {
    final student = _students.firstWhere((s) => s.id == studentId);
    student.testMarks[month] = marks;
    notifyListeners();
  }

  int get totalStudents => _students.length;

  int get presentToday {
    final today = DateTime.now().toString().split(' ')[0];
    return _students.where((s) => s.attendance[today] == true).length;
  }

  double get attendancePercentage {
    final today = DateTime.now().toString().split(' ')[0];
    final totalAttendanceRecords = _students.where((s) => s.attendance.containsKey(today)).length;
    if (totalAttendanceRecords == 0) return 0.0;
    return (presentToday / totalAttendanceRecords) * 100;
  }
}