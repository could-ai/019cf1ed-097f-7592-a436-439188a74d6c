import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class TestManagementScreen extends StatefulWidget {
  const TestManagementScreen({super.key});

  @override
  State<TestManagementScreen> createState() => _TestManagementScreenState();
}

class _TestManagementScreenState extends State<TestManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _marksController = TextEditingController();
  String _selectedStudentId = '';
  String _selectedMonth = 'January';

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Test Management',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFA5D6A7),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Record Test Marks',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedStudentId.isEmpty ? null : _selectedStudentId,
                      decoration: const InputDecoration(labelText: 'Select Student'),
                      items: provider.students.map((student) {
                        return DropdownMenuItem(
                          value: student.id,
                          child: Text('${student.name} (${student.studentClass})'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedStudentId = value ?? ''),
                      validator: (value) => value?.isEmpty ?? true ? 'Please select a student' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(labelText: 'Select Month'),
                      items: _months.map((month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedMonth = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _marksController,
                      decoration: const InputDecoration(
                        labelText: 'Marks (out of 100)',
                        suffixText: '/100',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please enter marks';
                        final marks = double.tryParse(value!);
                        if (marks == null || marks < 0 || marks > 100) {
                          return 'Marks must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _recordMarks,
                      child: const Text('Record Marks'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Test Results',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  final student = provider.students[index];
                  return ExpansionTile(
                    leading: const Icon(Icons.assignment, color: Color(0xFFA5D6A7)),
                    title: Text(
                      student.name,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      student.studentClass,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    children: student.testMarks.entries.map((entry) {
                      return ListTile(
                        title: Text(
                          '${entry.key}: ${entry.value}/100',
                          style: GoogleFonts.poppins(),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getGradeColor(entry.value),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getGrade(entry.value),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _recordMarks() {
    if (!_formKey.currentState!.validate()) return;

    final marks = double.parse(_marksController.text);
    Provider.of<StudentProvider>(context, listen: false)
        .addTestMarks(_selectedStudentId, _selectedMonth, marks);

    _marksController.clear();
    setState(() {
      _selectedStudentId = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marks recorded successfully!')),
    );
  }

  String _getGrade(double marks) {
    if (marks >= 90) return 'A';
    if (marks >= 80) return 'B';
    if (marks >= 70) return 'C';
    if (marks >= 60) return 'D';
    return 'F';
  }

  Color _getGradeColor(double marks) {
    if (marks >= 90) return const Color(0xFFA5D6A7);
    if (marks >= 80) return const Color(0xFFFFD54F);
    if (marks >= 70) return const Color(0xFFF8BBD9);
    return const Color(0xFFEF5350);
  }
}