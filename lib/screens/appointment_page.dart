/*import 'package:flutter/material.dart';
import 'doctor_info_booking_screen.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data for now
  List<Map<String, dynamic>> upcoming = [
    {
      "doctorId": "1",
      "doctorName": "Dr. Alice Tan",
      "photo": "https://randomuser.me/api/portraits/women/44.jpg",
      "date": "2025-09-10",
      "time": "10:00 AM",
    },
  ];
  List<Map<String, dynamic>> past = [
    {
      "doctorId": "2",
      "doctorName": "Dr. John Lee",
      "photo": "https://randomuser.me/api/portraits/men/32.jpg",
      "date": "2025-08-20",
      "time": "2:00 PM",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _cancelBooking(int index) {
    setState(() {
      upcoming.removeAt(index);
    });
  }

  void _viewDoctorInfo(String doctorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorInfoBookingScreen(doctorId: doctorId),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: "Upcoming"), Tab(text: "Past")],
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming
                ListView.builder(
                  itemCount: upcoming.length,
                  itemBuilder: (context, i) {
                    final appt = upcoming[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            appt["photo"],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(appt["doctorName"]),
                        subtitle: Text("${appt["date"]} at ${appt["time"]}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed:
                                  () => _viewDoctorInfo(appt["doctorId"]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => _cancelBooking(i),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Past
                ListView.builder(
                  itemCount: past.length,
                  itemBuilder: (context, i) {
                    final appt = past[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            appt["photo"],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(appt["doctorName"]),
                        subtitle: Text("${appt["date"]} at ${appt["time"]}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => _viewDoctorInfo(appt["doctorId"]),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'doctor_info_booking_screen.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data for now
  List<Map<String, dynamic>> upcoming = [
    {
      "doctorId": "1",
      "doctorName": "Dr. Alice Tan",
      "photo": "https://randomuser.me/api/portraits/women/44.jpg",
      "date": "2025-09-10",
      "time": "10:00 AM",
    },
  ];
  List<Map<String, dynamic>> past = [
    {
      "doctorId": "2",
      "doctorName": "Dr. John Lee",
      "photo": "https://randomuser.me/api/portraits/men/32.jpg",
      "date": "2025-08-20",
      "time": "2:00 PM",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _cancelBooking(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Cancel Appointment"),
            content: const Text(
              "Are you sure you want to cancel this appointment?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // close dialog
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    upcoming.removeAt(index);
                  });
                  Navigator.pop(context); // close dialog
                },
                child: const Text("Yes", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _viewDoctorInfo(String doctorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorInfoBookingScreen(doctorId: doctorId),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: "Upcoming"), Tab(text: "Past")],
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming
                ListView.builder(
                  itemCount: upcoming.length,
                  itemBuilder: (context, i) {
                    final appt = upcoming[i];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        height: 170, // increased card height
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    appt["photo"],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        appt["doctorName"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${appt["date"]} at ${appt["time"]}",
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed:
                                      () => _viewDoctorInfo(appt["doctorId"]),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () => _cancelBooking(i),
                                child: const Text("Cancel"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Past
                ListView.builder(
                  itemCount: past.length,
                  itemBuilder: (context, i) {
                    final appt = past[i];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        height: 120, // Bigger card
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                appt["photo"],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appt["doctorName"],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("${appt["date"]} at ${appt["time"]}"),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed:
                                  () => _viewDoctorInfo(appt["doctorId"]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
