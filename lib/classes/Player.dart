class Player {
  String name;
  String wins;
  String losses;
  String wps;
  double worth = 0.0;

  Player(this.name, this.wins, this.losses, this.wps) {
    // worth =
    //     double.parse(wps) * (1 + (int.parse(wins) - int.parse(losses)) / 25) +
    //         (int.parse(wins) - int.parse(losses)) / 200;
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
}
