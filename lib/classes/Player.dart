import 'package:flutter/material.dart';

class Player {
  String name;
  String wins;
  String losses;
  String wps;
  double worth = 0.0;
  bool isChosen = false;

  Player(this.name, this.wins, this.losses, this.wps) {
    try {
      worth =
          double.parse(wps) * (1 + (int.parse(wins) - int.parse(losses)) / 25) +
              (int.parse(wins) - int.parse(losses)) / 200;
    } catch (e) {
      debugPrint("Invalid");
    }
  }

  bool operator <(Player other) {
    double thisWP = double.parse(wps);
    double otherWP = double.parse(other.wps);

    if (thisWP == otherWP) {
      if (int.parse(wins) == int.parse(other.wins)) {
        return int.parse(losses) < int.parse(other.losses);
      } else {
        return int.parse(wins) > int.parse(other.wins);
      }
    }

    return thisWP > otherWP;
  }

  bool operator >(Player other) {
    double thisWP = double.parse(wps);
    double otherWP = double.parse(other.wps);

    if (thisWP == otherWP) {
      if (int.parse(wins) == int.parse(other.wins)) {
        return int.parse(losses) > int.parse(other.losses);
      } else {
        return int.parse(wins) < int.parse(other.wins);
      }
    }

    return thisWP < otherWP;
  }

  double getWorth() {
    return worth;
  }
}
