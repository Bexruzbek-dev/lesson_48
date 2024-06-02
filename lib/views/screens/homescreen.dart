import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? name;
int? age;
List? colors;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final colorController = TextEditingController();

  Future<void> saveData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      "Name",
      nameController.text,
    );
    await sharedPreferences.setInt(
      "age",
      int.tryParse(ageController.text)!,
    );
    await sharedPreferences.setStringList(
      "colors",
      colorController.text.split(","),
    );
  }

  Future<void> getData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString("Name");
    age = sharedPreferences.getInt("age");
    colors = sharedPreferences.getStringList("colors");

    setState(() {});
  }

  Color getColorFromString(String input) {
    List<int> bytes = utf8.encode(input);
    int hash = 0;
    for (int byte in bytes) {
      hash = (((hash << 5) - hash) + byte) & 0xFFFFFFFF;
    }

    int r = (hash & 0xFF0000) >> 16;
    int g = (hash & 0x00FF00) >> 8;
    int b = (hash & 0x0000FF);


    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shared Preferences"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(60),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your age',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: colorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your favorite colors',
                ),
              ),
            ),
            Gap(10),
            ElevatedButton(
              onPressed: () {
                saveData();
              },
              child: Text("Saqlash"),
            ),
            Gap(10),
            ElevatedButton(
              onPressed: () {
                getData();
              },
              child: Text("Olish"),
            ),
            Gap(20),
            Text(name == null || age == null
                ? ""
                : "Name: $name \nAge: $age \nRanglar: "),
            Column(
              children: [
                if (colors != null)
                  for (var i = 0; i < colors!.length; i++)
                    Text(
                      colors![i],
                      style: TextStyle(
                        color: getColorFromString(
                          colors![i],
                        ),
                      ),
                    ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
