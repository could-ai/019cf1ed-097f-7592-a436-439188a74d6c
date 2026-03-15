import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';

class StudentDirectoryScreen extends StatefulWidget {
  const StudentDirectoryScreen({super.key});

  @override
  State<StudentDirectoryScreen> createState() => _StudentDirectoryScreenState();
}

class _StudentDirectoryScreenState extends State<StudentDirectoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _classController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _feePaid = true;
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Directory',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFA5D6A7),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Student'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  final student = provider.students[index];
                  return ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFFA5D6A7)),
                    title: Text(student.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${student.studentClass} • ${student.fatherName} • ${student.phone}',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: student.feePaid ? const Color(0xFFA5D6A7) : const Color(0xFFF8BBD9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            student.feePaid ? 'Paid' : 'Unpaid',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFFA5D6A7)),
                          onPressed: () => _showAddEditDialog(context, student: student),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFFF8BBD9)),
                          onPressed: () => _deleteStudent(student.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {Student? student}) {
    if (student != null) {
      _editingId = student.id;
      _nameController.text = student.name;
      _fatherNameController.text = student.fatherName;
      _classController.text = student.studentClass;
      _phoneController.text = student.phone;
      _feePaid = student.feePaid;
    } else {
      _editingId = null;
      _nameController.clear();
      _fatherNameController.clear();
      _classController.clear();
      _phoneController.clear();
      _feePaid = true;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          student == null ? 'Add Student' : 'Edit Student',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _fatherNameController,
                  decoration: const InputDecoration(labelText: "Father's Name"),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(labelText: 'Class'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                SwitchListTile(
                  title: const Text('Fee Paid'),
                  value: _feePaid,
                  onChanged: (value) => setState(() => _feePaid = value),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveStudent,
            child: Text(student == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _saveStudent() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<StudentProvider>(context, listen: false);
    final student = Student(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      fatherName: _fatherNameController.text,
      studentClass: _classController.text,
      phone: _phoneController.text,
      feePaid: _feePaid,
    );

    if (_editingId != null) {
      provider.updateStudent(_editingId!, student);
    } else {
      provider.addStudent(student);
    }

    Navigator.pop(context);
  }

  void _deleteStudent(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<StudentProvider>(context, listen: false).deleteStudent(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}