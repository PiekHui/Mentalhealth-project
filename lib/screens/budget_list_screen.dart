import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetListScreen extends StatelessWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget List',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
      ),
      body: Center(
        child: Text(
          'Your budget items will appear here.',
          style: GoogleFonts.fredoka(fontSize: 18, color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
