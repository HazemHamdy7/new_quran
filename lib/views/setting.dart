// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// double arabicFontSize = 28;  
// double mushafFontSize = 40;  

// class Settings extends StatefulWidget {
//   const Settings({super.key});

//   @override
//   State<Settings> createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   @override
//   void initState() {
//     super.initState();
//     _loadSettings(); // Load settings when the screen is initialized
//   }

//   // Load saved settings from SharedPreferences
//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       arabicFontSize = prefs.getDouble('arabicFontSize') ?? 28;
//       mushafFontSize = prefs.getDouble('mushafFontSize') ?? 40;
//     });
//   }

//   // Save settings to SharedPreferences
//   Future<void> saveSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('arabicFontSize', arabicFontSize);
//     await prefs.setDouble('mushafFontSize', mushafFontSize);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Settings",
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: const Color.fromARGB(255, 56, 115, 59),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const Text(
//                     'Arabic Font Size:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   ),
//                   Slider(
//                     activeColor: const Color.fromARGB(255, 56, 115, 59),
//                     value: arabicFontSize,
//                     min: 20,
//                     max: 40,
//                     onChanged: (value) {
//                       setState(() {
//                         arabicFontSize = value;
//                       });
//                     },
//                   ),
//                   Text(
//                     "بسم الله الرحمن الرحيم",
//                     style: TextStyle(
//                         fontFamily: 'quran', fontSize: arabicFontSize),
//                     textDirection: TextDirection.rtl,
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(top: 10, bottom: 10),
//                     child: Divider(),
//                   ),
//                   const Text(
//                     'Mushaf Mode Font Size:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   ),
//                   Slider(
//                     activeColor: const Color.fromARGB(255, 56, 115, 59),
//                     value: mushafFontSize,
//                     min: 20,
//                     max: 50,
//                     onChanged: (value) {
//                       setState(() {
//                         mushafFontSize = value;
//                       });
//                     },
//                   ),
//                   Text(
//                     "بسم الله الرحمن الرحيم",
//                     style: TextStyle(
//                         fontFamily: 'quran', fontSize: mushafFontSize),
//                     textDirection: TextDirection.rtl,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         style: const ButtonStyle(
//                           foregroundColor: WidgetStatePropertyAll(Colors.white),
//                           backgroundColor: WidgetStatePropertyAll(
//                               Color.fromARGB(255, 56, 115, 59)),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             arabicFontSize = 28;
//                             mushafFontSize = 40;
//                           });
//                           saveSettings(); // Save default settings
//                         },
//                         child: const Text('Reset'),
//                       ),
//                       ElevatedButton(
//                         style: const ButtonStyle(
//                           foregroundColor: WidgetStatePropertyAll(Colors.white),
//                           backgroundColor: WidgetStatePropertyAll(
//                               Color.fromARGB(255, 56, 115, 59)),
//                         ),
//                         onPressed: () {
//                           saveSettings(); // Save the updated settings
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Save'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
