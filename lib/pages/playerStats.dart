import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../classes/Player.dart';

// ignore: must_be_immutable
class PlayerStats extends StatelessWidget {
  List<Player> playerList;
  PlayerStats({Key? key, required this.playerList}) : super(key: key);

  List<Player> merge(List<Player> A, int low, int mid, int high) {
    int n1 = mid - low + 1;
    int n2 = high - mid;
    Player empty = Player("", "", "", "");
    List<Player> firstHalf = List<Player>.filled(n1, empty);
    List<Player> secondHalf = List<Player>.filled(n2, empty);

    for (int i = 0; i < n1; i++) {
      firstHalf[i] = A[low + i];
    }

    for (int i = 0; i < n2; i++) {
      secondHalf[i] = A[mid + i + 1];
    }

    int i1 = 0;
    int i2 = 0;

    int mergedI = low;

    while (i1 < n1 && i2 < n2) {
      if (firstHalf[i1] < secondHalf[i2]) {
        A[mergedI] = firstHalf[i1];
        i1++;
      } else {
        A[mergedI] = secondHalf[i2];
        i2++;
      }
      mergedI++;
    }

    while (i1 < n1) {
      A[mergedI] = firstHalf[i1];
      mergedI++;
      i1++;
    }

    while (i2 < n2) {
      A[mergedI] = secondHalf[i2];
      mergedI++;
      i2++;
    }

    return A;
  }

  List<Player> mergeSort(List<Player> playerList, int low, int high) {
    if (low < high) {
      int mid = (low + high) ~/ 2;
      mergeSort(playerList, low, mid);
      mergeSort(playerList, mid + 1, high);
      playerList = merge(playerList, low, mid, high);
    }

    return playerList;
  }

  List<Player> createButtons() {
    List<Player> players = [];
    Player first = Player('Name', 'Wins', 'Losses', 'Win Percentage');
    players.add(first);
    for (int i = 0; i < playerList.length; i++) {
      double unrounded = double.parse(playerList[i].wps) * 100;
      // String winP = ('Win%: ' + unrounded.round().toString() + "%");
      Player eachPlayer = Player(
          playerList[i].name.toString(),
          playerList[i].wins.toString(),
          playerList[i].losses.toString(),
          unrounded.round().toString());
      players.add(eachPlayer);
    }
    playerList = mergeSort(players, 1, players.length - 1);
    debugPrint("Sorted");
    return players;
  }

  @override
  Widget build(BuildContext context) {
    List<Player> list = createButtons();
    // Access the snapshot here
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.back_hand))
        ],
        title: Text('Player Stats'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: playerList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 1) {}
            return GestureDetector(
                child: Container(
                    height: 45.0,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          // no padding
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(10.0))),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(playerList[index].name,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(playerList[index].wins,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(playerList[index].losses,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              "${playerList[index].wps}%",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )

                    //note
                    ));
          },
        ),
      ),
    );
  }
}
