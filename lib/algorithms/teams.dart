import 'package:flutter/cupertino.dart';

import "../classes/Player.dart";

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

double calcAvg(List<Player> team) {
  double sum = 0;

  for (int i = 0; i < team.length; i++) {
    sum += team[i].worth;
  }

  double avg = sum / (team.length * 1.0);

  return avg;
}

Pair<List<Player>, List<Player>> createTeams(List<Player> playersPlaying) {
  // sort the players by worth in decreasing order
  playersPlaying.sort((a, b) => b.worth.compareTo(a.worth));

  List<Player> team1 = [];
  List<Player> team2 = [];

  double team1Worth = 0.0;
  double team2Worth = 0.0;

  // divide the players into two teams, alternating players
  for (int i = 0; i < playersPlaying.length; i++) {
    if (i % 2 == 0) {
      team1.add(playersPlaying[i]);
      team1Worth += playersPlaying[i].worth;
    } else {
      team2.add(playersPlaying[i]);
      team2Worth += playersPlaying[i].worth;
    }
  }

  team1Worth /= team1.length;
  team2Worth /= team2.length;

  // calculate the initial average worth of each team

  // loop 5 times to try to improve the team balance
  for (int j = 0; j < 5; j++) {
    // keep track of the best team configuration found so far
    List<Player> bestTeam1 = team1;
    List<Player> bestTeam2 = team2;
    double bestDiff = (team1Worth - team2Worth).abs();

    List<Player> newTeam1 = [];
    List<Player> newTeam2 = [];
    // try swapping each player to the other team and see if it improves the balance
    for (int i = 0; i < team1.length; i++) {
      for (int j = 0; j < team2.length; j++) {
        newTeam1 = team1;
        newTeam2 = team2;
        Player p1 = team1[i];
        Player p2 = team2[j];
        newTeam1[i] = p2;
        newTeam2[j] = p1;
      }
      // calculate the new average worth of each team
      double newTeam1Worth = calcAvg(newTeam1);
      double newTeam2Worth = calcAvg(newTeam2);

      // check if this configuration is better than the previous best
      double newDiff = (newTeam1Worth - newTeam2Worth).abs();
      if (newDiff < bestDiff) {
        bestTeam1 = newTeam1;
        bestTeam2 = newTeam2;
        bestDiff = newDiff;
      }

      // check if the best configuration found is better than the current one

    }
    if (bestDiff < 0.5) {
      team1 = bestTeam1;
      team2 = bestTeam2;
      break;
    } else {
      team1 = bestTeam1;
      team2 = bestTeam2;
      team1Worth = calcAvg(team1);
      team2Worth = calcAvg(team2);
    }
  }

  debugPrint("Team 1");
  for (int i = 0; i < team1.length; i++) {
    debugPrint(team1[i].name);
  }

  debugPrint("Team 2:");

  for (int i = 0; i < team2.length; i++) {
    debugPrint(team2[i].name);
  }
  return Pair(team1, team2);
}
