import 'package:flutter/material.dart';

class UnlockPetsPage extends StatelessWidget {
  const UnlockPetsPage({super.key});

  final List<Map<String, dynamic>> pets = const [
    {
      "name": "Buddy",
      "coins": 500,
      "gender": "Male",
      "type": "Dog",
      "rarity": "Common",
      "image": "assets/dog.jpg",
    },
    {
      "name": "Mimi",
      "coins": 800,
      "gender": "Female",
      "type": "Cat",
      "rarity": "Rare",
      "image": "assets/cat.jpg",
    },
    {
      "name": "Coco",
      "coins": 1000,
      "gender": "Female",
      "type": "Rabbit",
      "rarity": "Epic",
      "image": "assets/bunny.jpg",
    },
  ];

  // 🎨 Colors based on rarity
  Color getRarityColor(String rarity) {
    switch (rarity) {
      case "Common":
        return Colors.grey.shade400;
      case "Rare":
        return Colors.blueAccent;
      case "Epic":
        return Colors.deepPurpleAccent;
      default:
        return Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unlock New Pets"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return Card(
            color: getRarityColor(pet["rarity"] as String).withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(pet["image"] as String),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pet["name"] as String,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: getRarityColor(pet["rarity"] as String),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Type: ${pet["type"]} • Gender: ${pet["gender"]}"),
                  Text("Rarity: ${pet["rarity"]}"),
                  const SizedBox(height: 6),
                  Text(
                    "Unlock for ${pet["coins"]} coins",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 198, 151),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 🔒 Show confirmation popup
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Unlock"),
                          content: Text(
                              "Are you sure you want to unlock ${pet["name"]} for ${pet["coins"]} coins?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // close dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("${pet["name"]} unlocked! 🎉"),
                                    backgroundColor: getRarityColor(
                                        pet["rarity"] as String),
                                  ),
                                );
                              },
                              child: const Text("Yes, Unlock"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock_open),
                    label: const Text("Unlock"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getRarityColor(pet["rarity"] as String),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
