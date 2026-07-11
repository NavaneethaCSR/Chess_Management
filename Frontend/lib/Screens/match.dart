import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


final teamAProvider = StateProvider<List<String>>((ref) => []);
final teamBProvider = StateProvider<List<String>>((ref) => []);
final pairsProvider = StateProvider<List<String>>((ref) => []);
final pairsProvider1 = StateProvider<List<String>>((ref) => []);

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamA = ref.watch(teamAProvider);
    final teamB = ref.watch(teamBProvider);
    final pairs = ref.watch(pairsProvider);
    final pairs1 = ref.watch(pairsProvider1);
    final teamAController = TextEditingController();
    final teamBController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("TEAM DETAILS"),),
     body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: teamAController, decoration: const InputDecoration(labelText: "Enter Team A")),
            TextField(controller: teamBController, decoration: const InputDecoration(labelText: "Enter Team B")),
            ElevatedButton(
            onPressed: () async {
  final newTeamA = List.generate(
    int.parse(teamAController.text),
    (i) => (i + 1).toString(),
  );

  final newTeamB = List.generate(
    int.parse(teamBController.text),
    (i) => (i + 1).toString(),
  );

  ref.read(teamAProvider.notifier).state = newTeamA;
  ref.read(teamBProvider.notifier).state = newTeamB;

  await savePlayers(ref, newTeamA, newTeamB);
},
              child: const Text("Save"),
            ),
            Text("PLAYERS OF EACH TEAMS GIVEN BELOW:"),
            Text("Team A: $teamA"),
            Text("Team B: $teamB"),
            ElevatedButton(
              onPressed: () async => await pair(ref),
              child: const Text("Pair"),
            ),const Text(
  "TOURNAMENT",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),
           const Text("PLAYERS OF EACH MATCH:"),

...pairs1.map((p) => Text(p)).toList(),

const SizedBox(height: 20),
const Text(
  "TOP 3 WINNERS:",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

...pairs.map((p) => Text(p)).toList(),
          ],
        ),
      ),
    ),);
  }
}





Future<void> savePlayers(WidgetRef ref, List<String> teamA, List<String> teamB) async {
  List<Map<String, dynamic>> players = [
    for (var player in teamA) {"name": player, "team": "A"},
    for (var player in teamB) {"name": player, "team": "B"},
  ];

  final response = await http.post(
    Uri.parse("http://localhost:3000/players"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"players": players}),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Players saved");
  } else {
    print(response.body);
  }
}

Future<void> pair(WidgetRef ref) async {
  final response = await http.post(
    Uri.parse("http://localhost:3000/tournaments"),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    Map<int, int> winnerCount = {};
ref.read(pairsProvider1.notifier).state = [
  for (var match in data["matches"])
    "${match["playerA"]} vs ${match["playerB"]} → Winner: ${match["winner"]}"
];
    for (var match in data["matches"]) {
   
       int winner = int.parse(match["winner"].toString());
      winnerCount[winner] = (winnerCount[winner] ?? 0) + 1;
    }

    // Sort by wins
    var top3 = winnerCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Store in provider
    ref.read(pairsProvider.notifier).state = [
      for (var entry in top3.take(3))
        ("Player ${entry.key} → ${entry.value} wins" )   
    ];
    
  }
  
}
