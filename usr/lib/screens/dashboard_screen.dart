import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Bloom Academy',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFA5D6A7),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Students',
                  provider.totalStudents.toString(),
                  Icons.people,
                  const Color(0xFFF8BBD9),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildSummaryCard(
                  'Present Today',
                  '${provider.presentToday}/${provider.totalStudents}',
                  Icons.check_circle,
                  const Color(0xFFA5D6A7),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildSummaryCard(
                  'Attendance %',
                  '${provider.attendancePercentage.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  const Color(0xFFFFD54F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildActionButton('Add Student', Icons.person_add, () {
                // Navigate to student directory
              }),
              const SizedBox(width: 20),
              _buildActionButton('Mark Attendance', Icons.check, () {
                // Navigate to attendance
              }),
              const SizedBox(width: 20),
              _buildActionButton('Record Test', Icons.assignment, () {
                // Navigate to tests
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
              ],
            ),
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.local_florist, color: Color(0xFFF8BBD9), size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title, style: GoogleFonts.poppins()),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
