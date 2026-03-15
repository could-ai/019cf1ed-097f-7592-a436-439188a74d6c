import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();

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
                'Daily Attendance Tracker',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFA5D6A7),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: GoogleFonts.poppins(),
                ),
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
                  final dateKey = _selectedDate.toString().split(' ')[0];
                  final isPresent = student.attendance[dateKey] ?? false;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPresent ? const Color(0xFFA5D6A7) : const Color(0xFFF8BBD9),
                      child: Icon(
                        isPresent ? Icons.check : Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      student.name,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      student.studentClass,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => provider.markAttendance(student.id, dateKey, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPresent ? const Color(0xFFA5D6A7) : Colors.grey[300],
                            foregroundColor: isPresent ? Colors.white : Colors.black,
                          ),
                          child: const Text('Present'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => provider.markAttendance(student.id, dateKey, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isPresent ? const Color(0xFFF8BBD9) : Colors.grey[300],
                            foregroundColor: !isPresent ? Colors.white : Colors.black,
                          ),
                          child: const Text('Absent'),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}