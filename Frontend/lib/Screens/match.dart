import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


final teamAProvider = StateProvider<List<String>>((ref) => []);
final teamBProvider = StateProvider<List<String>>((ref) => []);
final pairsProvider = StateProvider<List<String>>((ref) => []);

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamA = ref.watch(teamAProvider);
    final teamB = ref.watch(teamBProvider);
    final pairs = ref.watch(pairsProvider);

    final teamAController = TextEditingController();
    final teamBController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Team Input")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: teamAController, decoration: const InputDecoration(labelText: "Enter Team A")),
            TextField(controller: teamBController, decoration: const InputDecoration(labelText: "Enter Team B")),
            ElevatedButton(
              onPressed: () async {
                ref.read(teamAProvider.notifier).state =
                    List.generate(int.parse(teamAController.text), (i) => (i + 1).toString());
                ref.read(teamBProvider.notifier).state =
                    List.generate(int.parse(teamBController.text), (i) => (i + 1).toString());
                await savePlayers(ref, teamA, teamB);
              },
              child: const Text("Save"),
            ),
            Text("Team A: $teamA"),
            Text("Team B: $teamB"),
            ElevatedButton(
              onPressed: () async => await pair(ref),
              child: const Text("Pair"),
            ),
            ...pairs.map((p) => Text(p)).toList(),
          ],
        ),
      ),
    );
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
    ref.read(pairsProvider.notifier).state = [
      for (var match in data["matches"])
        "${match["playerA"]} vs ${match["playerB"]} → Winner: ${match["winner"]}"
    ];
  }
}
