/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  String? selectedAge;
  String? selectedGender;
  String? selectedYear;

  final List<String> ageOptions = ['Any', '20-30', '31-40', '41-50', '51+'];
  final List<String> genderOptions = ['Any', 'Male', 'Female', 'Other'];
  final List<String> yearOptions = ['Any', '1-5', '6-10', '11-20', '20+'];

  @override
  void initState() {
    super.initState();
    selectedAge = ageOptions[0];
    selectedGender = genderOptions[0];
    selectedYear = yearOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consultation',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intro Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  // Replace icon with image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://i.pinimg.com/originals/7c/3b/21/7c3b2108b4e879150933bf612879937e.png",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Intro text
                  Expanded(
                    child: Text(
                      "Welcome! Here you can book appointments and chat with a professional for mental health support!",
                      style: GoogleFonts.fredoka(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 🔹 Appointment & Chat Buttons (KEEPED)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to AppointmentPage
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Appointment',
                      style: GoogleFonts.fredoka(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to ChatPage
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Chat',
                      style: GoogleFonts.fredoka(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // 🔹 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search doctor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Filter Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedAge,
                    items:
                        ageOptions
                            .map(
                              (age) => DropdownMenuItem(
                                value: age,
                                child: Text(age),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedAge = val),
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    items:
                        genderOptions
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedGender = val),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    items:
                        yearOptions
                            .map(
                              (y) => DropdownMenuItem(value: y, child: Text(y)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedYear = val),
                    decoration: InputDecoration(
                      labelText: 'Working Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // 🔹 Doctor Cards (Grid 2 per row)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: [
                  _DoctorCard(
                    name: "Dr. Alice Tan",
                    specialty: "Clinical Psychologist",
                    imageUrl:
                        "https://randomuser.me/api/portraits/women/44.jpg",
                    age: "35",
                    workingExperience: "10",
                    onTap: () {},
                  ),
                  _DoctorCard(
                    name: "Dr. John Lee",
                    specialty: "Counselor",
                    imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
                    age: "42",
                    workingExperience: "15",
                    onTap: () {},
                  ),
                  _DoctorCard(
                    name: "Dr. Maria Lim",
                    specialty: "Psychiatrist",
                    imageUrl:
                        "https://randomuser.me/api/portraits/women/68.jpg",
                    age: "45",
                    workingExperience: "20",
                    onTap: () {},
                  ),
                  _DoctorCard(
                    name: "Dr. Daniel Wong",
                    specialty: "Therapist",
                    imageUrl: "https://randomuser.me/api/portraits/men/12.jpg",
                    age: "38",
                    workingExperience: "12",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;
  final String age;
  final String workingExperience;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.age,
    required this.workingExperience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: 80, // bigger image
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                specialty,
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              Text("Age: $age", style: GoogleFonts.fredoka(fontSize: 13)),
              Text(
                "Exp: $workingExperience yrs",
                style: GoogleFonts.fredoka(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'doctor_info_booking_screen.dart'; // <-- import your page
import 'appointment_page.dart';
import 'chat_page.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  String? selectedAge;
  String? selectedGender;
  String? selectedYear;

  final List<String> ageOptions = ['Any', '20-30', '31-40', '41-50', '51+'];
  final List<String> genderOptions = ['Any', 'Male', 'Female', 'Other'];
  final List<String> yearOptions = ['Any', '1-5', '6-10', '11-20', '20+'];

  // 🔹 Centralized Doctor Data
  final List<Map<String, dynamic>> doctors = [
    {
      "id": "1",
      "name": "Dr. Alice Tan",
      "specialty": "Clinical Psychologist",
      "photo": "https://randomuser.me/api/portraits/women/44.jpg",
      "age": "35",
      "experience": "10",
      "rating": "4.8",
      "bookings": "120",
      "intro":
          "Experienced clinical psychologist specializing in anxiety and depression.",
      "location": "Kuala Lumpur General Hospital",
      "university": "University of Malaya",
      "reviews": [
        {"user": "Jane", "comment": "Very helpful!", "rating": 5},
        {"user": "Ben", "comment": "Kind and professional.", "rating": 4},
      ],
    },
    {
      "id": "2",
      "name": "Dr. John Lee",
      "specialty": "Counselor",
      "photo": "https://randomuser.me/api/portraits/men/32.jpg",
      "age": "42",
      "experience": "15",
      "rating": "4.6",
      "bookings": "98",
      "intro": "Professional counselor with focus on stress management.",
      "location": "Penang Hospital",
      "university": "Universiti Sains Malaysia",
      "reviews": [
        {"user": "Alicia", "comment": "Great listener.", "rating": 5},
      ],
    },
    {
      "id": "3",
      "name": "Dr. Maria Lim",
      "specialty": "Psychiatrist",
      "photo": "https://randomuser.me/api/portraits/women/68.jpg",
      "age": "45",
      "experience": "20",
      "rating": "4.9",
      "bookings": "150",
      "intro": "Psychiatrist with 20 years of experience in clinical practice.",
      "location": "Sabah Medical Centre",
      "university": "National University of Singapore",
      "reviews": [
        {"user": "Tom", "comment": "Very professional!", "rating": 5},
      ],
    },
    {
      "id": "4",
      "name": "Dr. Daniel Wong",
      "specialty": "Therapist",
      "photo": "https://randomuser.me/api/portraits/men/12.jpg",
      "age": "38",
      "experience": "12",
      "rating": "4.7",
      "bookings": "110",
      "intro": "Therapist specializing in family and relationship counseling.",
      "location": "Selangor Specialist Clinic",
      "university": "Taylor's University",
      "reviews": [
        {"user": "Emily", "comment": "Really helped me a lot.", "rating": 5},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedAge = ageOptions[0];
    selectedGender = genderOptions[0];
    selectedYear = yearOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consultation',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intro Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://i.pinimg.com/originals/7c/3b/21/7c3b2108b4e879150933bf612879937e.png",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Welcome! Here you can book appointments and chat with a professional for mental health support!",
                      style: GoogleFonts.fredoka(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Appointment & Chat Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppointmentPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Appointment',
                      style: GoogleFonts.fredoka(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Chat',
                      style: GoogleFonts.fredoka(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search doctor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 12),

            // Filter Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedAge,
                    items:
                        ageOptions
                            .map(
                              (age) => DropdownMenuItem(
                                value: age,
                                child: Text(age),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedAge = val),
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    items:
                        genderOptions
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedGender = val),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    items:
                        yearOptions
                            .map(
                              (y) => DropdownMenuItem(value: y, child: Text(y)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedYear = val),
                    decoration: InputDecoration(
                      labelText: 'Working Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Doctor Cards Grid
            Expanded(
              child: GridView.builder(
                itemCount: doctors.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return _DoctorCard(
                    name: doctor["name"],
                    specialty: doctor["specialty"],
                    imageUrl: doctor["photo"],
                    age: doctor["age"],
                    workingExperience: doctor["experience"],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DoctorInfoBookingScreen(
                                doctorId: doctor["id"],
                              ),
                          settings: RouteSettings(
                            arguments: doctor,
                          ), // pass full data
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;
  final String age;
  final String workingExperience;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.age,
    required this.workingExperience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Text(
                specialty,
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              Text("Age: $age", style: GoogleFonts.fredoka(fontSize: 13)),
              Text(
                "Exp: $workingExperience yrs",
                style: GoogleFonts.fredoka(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
