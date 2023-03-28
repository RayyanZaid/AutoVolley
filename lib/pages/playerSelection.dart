import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../algorithms/teams.dart';
import '../classes/Player.dart';
import './MatchScreen.dart';
import '../algorithms/teams.dart' as teamAlgo;

class PlayerSelect {
  String strPlayerName;
  bool isChosen;

  PlayerSelect({required this.strPlayerName, this.isChosen = false});
}

List<PlayerSelect> convertToPlayerSelect(List<Player> playerList) {
  List<PlayerSelect> listToReturn = [];
  for (int i = 0; i < playerList.length; i++) {
    PlayerSelect p =
        PlayerSelect(strPlayerName: playerList[i].name, isChosen: false);
    listToReturn.add(p);
  }
  return listToReturn;
}

Map<String, dynamic> convertToMap(List<Player> playerList) {
  Map<String, dynamic> map = {};

  for (int i = 0; i < playerList.length; i++) {
    debugPrint(playerList[i].worth.toString());
    map[playerList[i].name] = playerList[i].worth.toString();
  }

  return map;
}

class PlayerSelection extends StatefulWidget {
  final List<Player> playerList;
  final Map<String, dynamic> playerMapping;
  final String uid;
  AsyncSnapshot<User?>? snapshot;
  PlayerSelection({
    required this.playerList,
    required this.playerMapping,
    required this.uid,
  });

  @override
  _PlayerSelectionState createState() => _PlayerSelectionState();
}

class _PlayerSelectionState extends State<PlayerSelection> {
  List<PlayerSelect> _playerListLocal = [];
  Map<String, dynamic> playerMapping = {};
  String uid = "";

  @override
  void initState() {
    super.initState();
    _playerListLocal = convertToPlayerSelect(widget.playerList);
    playerMapping = widget.playerMapping;
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double paddingHeight = height * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose who will play'),
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        child: ListView.builder(
          itemCount: _playerListLocal.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                child: Container(
                    height: height * .1,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: paddingHeight),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: const Radius.circular(10.0))),
                                child: Container(
                                    width: 120.0,
                                    height: 40.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                        _playerListLocal[index].strPlayerName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 62, 157, 239),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  debugPrint("Selected");

                                  setState(() {
                                    _playerListLocal[index].isChosen =
                                        !_playerListLocal[index].isChosen;
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(0.0),
                                    child: Icon(
                                      _playerListLocal[index].isChosen
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 30.0,
                                    )),
                              ),
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
      bottomNavigationBar: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(280, 80),
              textStyle: TextStyle(fontSize: 28),
              padding: EdgeInsets.only(top: 30, bottom: 30)),
          child: const Text('Start match'),
          onPressed: () {
            debugPrint(uid);
            debugPrint("hi");
            List<Player> team1 = [];
            List<Player> team2 = [];

            List<Player> playersPlaying = [];

            for (int i = 0; i < _playerListLocal.length; i++) {
              if (_playerListLocal[i].isChosen == true) {
                String name = _playerListLocal[i].strPlayerName;
                String wins = playerMapping[name]["wins"].toString();
                String losses = playerMapping[name]["losses"].toString();
                String wps = playerMapping[name]["winPercentage"].toString();
                Player p = Player(name, wins, losses, wps);
                if (i % 2 == 0) {
                  playersPlaying.add(p);
                } else {
                  playersPlaying.add(p);
                }
              }
            }

            Pair<List<Player>, List<Player>> teams =
                teamAlgo.createTeams(playersPlaying);

            team1 = teams.first;
            team2 = teams.second;

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MatchScreen(team1, team2, uid);
            }));
          }),
    );
  }
}
