/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorInfoBookingScreen extends StatefulWidget {
  final String doctorId;
  const DoctorInfoBookingScreen({super.key, required this.doctorId});

  @override
  State<DoctorInfoBookingScreen> createState() =>
      _DoctorInfoBookingScreenState();
}

class _DoctorInfoBookingScreenState extends State<DoctorInfoBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy doctor data
    final doctor = {
      "name": "Dr. Alice Tan",
      "photo": "https://randomuser.me/api/portraits/women/44.jpg",
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
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Info & Booking', style: GoogleFonts.fredoka()),
      ),
      body: Column(
        children: [
          // Doctor photo and name
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    doctor["photo"] as String,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    doctor["name"] as String,
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tab Switcher
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Schedule Appointment"),
              Tab(text: "About Me"),
            ],
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Schedule Appointment Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Date",
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 60),
                            ),
                          );
                          if (date != null) setState(() => selectedDate = date);
                        },
                        child: Text(
                          selectedDate == null
                              ? "Choose Date"
                              : "${selectedDate!.toLocal()}".split(' ')[0],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Select Time",
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) setState(() => selectedTime = time);
                        },
                        child: Text(
                          selectedTime == null
                              ? "Choose Time"
                              : selectedTime!.format(context),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            (selectedDate != null && selectedTime != null)
                                ? () {
                                  // Book logic here
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          "Book Appointment",
                          style: GoogleFonts.fredoka(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // About Me Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text("Experience: ${doctor["experience"]} years"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text("Rating: ${doctor["rating"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text("Successful Bookings: ${doctor["bookings"]}"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Intro:",
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                      Text(doctor["intro"] as String),
                      const SizedBox(height: 8),
                      Text("Location: ${doctor["location"]}"),
                      Text("University: ${doctor["university"]}"),
                      const SizedBox(height: 16),
                      Text(
                        "User Reviews",
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                      // Fix ListView inside Padding (use Flexible)
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...((doctor["reviews"] as List)
                                .cast<Map<String, dynamic>>()
                                .map<Widget>(
                                  (review) => ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(review["user"]),
                                    subtitle: Text(review["comment"]),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        review["rating"],
                                        (i) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

hhhl

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorInfoBookingScreen extends StatefulWidget {
  final String doctorId;
  const DoctorInfoBookingScreen({super.key, required this.doctorId});

  @override
  State<DoctorInfoBookingScreen> createState() =>
      _DoctorInfoBookingScreenState();
}

class _DoctorInfoBookingScreenState extends State<DoctorInfoBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy doctor data
    final doctor = {
      "name": "Dr. Alice Tan",
      "photo": "https://randomuser.me/api/portraits/women/44.jpg",
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
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Info & Booking', style: GoogleFonts.fredoka()),
      ),
      body: Column(
        children: [
          // Doctor photo and name
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    doctor["photo"] as String,
                    width: 160, // Bigger photo
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  doctor["name"] as String,
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Tab Switcher
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Schedule Appointment"),
              Tab(text: "About Me"),
            ],
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Schedule Appointment Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Date",
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 60),
                            ),
                          );
                          if (date != null) setState(() => selectedDate = date);
                        },
                        child: Text(
                          selectedDate == null
                              ? "Choose Date"
                              : "${selectedDate!.toLocal()}".split(' ')[0],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Select Time",
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) setState(() => selectedTime = time);
                        },
                        child: Text(
                          selectedTime == null
                              ? "Choose Time"
                              : selectedTime!.format(context),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            (selectedDate != null && selectedTime != null)
                                ? () {
                                  // Book logic here
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          "Book Appointment",
                          style: GoogleFonts.fredoka(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // About Me Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info cards in 3 columns
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          childAspectRatio: 0.9,
                          children: [
                            _buildInfoCard(
                              icon: Icons.school,
                              label: "Experience",
                              value: "${doctor["experience"]} yrs",
                            ),
                            _buildInfoCard(
                              icon: Icons.star,
                              label: "Rating",
                              value: doctor["rating"] as String,
                            ),
                            _buildInfoCard(
                              icon: Icons.check_circle,
                              label: "Bookings",
                              value: doctor["bookings"] as String,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Intro:",
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(doctor["intro"] as String),
                        const SizedBox(height: 8),
                        Text("Location: ${doctor["location"]}"),
                        Text("University: ${doctor["university"]}"),
                        const SizedBox(height: 16),
                        Text(
                          "User Reviews",
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children:
                              (doctor["reviews"] as List)
                                  .cast<Map<String, dynamic>>()
                                  .map<Widget>(
                                    (review) => Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue.shade100,
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(review["user"]),
                                        subtitle: Text(review["comment"]),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            review["rating"],
                                            (i) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';

class DoctorInfoBookingScreen extends StatefulWidget {
  final String doctorId;
  const DoctorInfoBookingScreen({super.key, required this.doctorId});

  @override
  State<DoctorInfoBookingScreen> createState() =>
      _DoctorInfoBookingScreenState();
}

class _DoctorInfoBookingScreenState extends State<DoctorInfoBookingScreen> {
  // Example available dates (next 3 days)
  final List<String> availableDates = [
    "Mon, Sep 8",
    "Tue, Sep 9",
    "Wed, Sep 10",
  ];

  // Example available times
  final List<String> availableTimes = ["3:00 PM", "5:00 PM", "7:00 PM"];

  String? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor photo bigger
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://randomuser.me/api/portraits/women/44.jpg", // example doctor photo
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Doctor Name
            Center(
              child: Text(
                "Dr. Alice Tan",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Clinical Psychologist",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),

            //About Me Section
            const SizedBox(height: 20),
            const Text(
              "About Me",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Hi there! I’m Dr. Alice Tan. I’ve been working as a doctor for more than "
              "10 years, and I really love meeting new people and helping them feel better. "
              "I believe in keeping things simple and making sure my patients feel "
              "comfortable, cared for, and listened to. Let’s work together on your health journey!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            // Info cards (Rating, Experience, Patients)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard("⭐ Rating", "4.8"),
                _buildInfoCard("👩‍⚕️ Years", "10"),
                _buildInfoCard("🧑‍🤝‍🧑 Patients", "230+"),
              ],
            ),
            const SizedBox(height: 24),

            // --- Booking Section ---
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    availableDates.map((date) {
                      final isSelected = date == selectedDate;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedDate = date);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.deepPurpleAccent
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            date,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Select Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  availableTimes.map((time) {
                    final isSelected = time == selectedTime;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedTime = time);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.deepPurpleAccent
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed:
                  (selectedDate != null && selectedTime != null)
                      ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Booked $selectedDate at $selectedTime",
                            ),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Confirm Appointment",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            // Reviews Section
            const Text(
              "Reviews",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildReview("Sarah", "Great doctor, very patient and helpful."),
            _buildReview("David", "Clear explanation and friendly."),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(String user, String comment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user),
        subtitle: Text(comment),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';

class DoctorInfoBookingScreen extends StatefulWidget {
  final String doctorId;
  const DoctorInfoBookingScreen({super.key, required this.doctorId});

  @override
  State<DoctorInfoBookingScreen> createState() =>
      _DoctorInfoBookingScreenState();
}

class _DoctorInfoBookingScreenState extends State<DoctorInfoBookingScreen> {
  // Example available dates (next 3 days)
  final List<String> availableDates = [
    "Mon, Sep 8",
    "Tue, Sep 9",
    "Wed, Sep 10",
  ];

  // Example available times
  final List<String> availableTimes = ["3:00 PM", "5:00 PM", "7:00 PM"];

  String? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Doctor Info"),
          bottom: const TabBar(
            tabs: [Tab(text: "About Me"), Tab(text: "Schedule")],
          ),
        ),
        body: TabBarView(
          children: [
            // ---------------- ABOUT ME TAB ----------------
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://randomuser.me/api/portraits/women/44.jpg",
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      "Dr. Alice Tan",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Clinical Psychologist",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),

                  // About Me section
                  const SizedBox(height: 20),
                  const Text(
                    "About Me",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Hi there! I’m Dr. Alice Tan. I’ve been working as a doctor for more than "
                    "10 years, and I really love meeting new people and helping them feel better. "
                    "I believe in keeping things simple and making sure my patients feel "
                    "comfortable, cared for, and listened to. Let’s work together on your health journey!",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info cards (Rating, Experience, Patients)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard("⭐ Rating", "4.8"),
                      _buildInfoCard("👩‍⚕️ Years", "10"),
                      _buildInfoCard("🧑‍🤝‍🧑 Patients", "230+"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Reviews Section
                  const Text(
                    "Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildReview(
                    "Sarah",
                    "Great doctor, very patient and helpful.",
                  ),
                  _buildReview("David", "Clear explanation and friendly."),
                ],
              ),
            ),

            // ---------------- SCHEDULE TAB ----------------
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Date",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          availableDates.map((date) {
                            final isSelected = date == selectedDate;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedDate = date);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.deepPurpleAccent
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Select Time",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        availableTimes.map((time) {
                          final isSelected = time == selectedTime;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedTime = time);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.deepPurpleAccent
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed:
                        (selectedDate != null && selectedTime != null)
                            ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Booked $selectedDate at $selectedTime",
                                  ),
                                ),
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Confirm Appointment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(String user, String comment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user),
        subtitle: Text(comment),
      ),
    );
  }
}
