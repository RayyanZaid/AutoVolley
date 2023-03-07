import 'package:flutter/material.dart';
import '../classes/Player.dart';
import './MatchScreen.dart';

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
    map[playerList[i].name] = playerList[i].worth;
  }

  return map;
}

class PlayerSelection extends StatefulWidget {
  final List<Player> playerList;

  PlayerSelection({required this.playerList});

  @override
  _PlayerSelectionState createState() => _PlayerSelectionState();
}

class _PlayerSelectionState extends State<PlayerSelection> {
  List<PlayerSelect> _playerListLocal = [];
  Map<String, dynamic> playerMapping = {};
  @override
  void initState() {
    super.initState();
    _playerListLocal = convertToPlayerSelect(widget.playerList);
    playerMapping = convertToMap(widget.playerList);
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
            List<Player> team1 = [];
            List<Player> team2 = [];
            int midIndex = (_playerListLocal.length / 2).floor();

            for (int i = 0; i < _playerListLocal.length; i++) {
              if (_playerListLocal[i].isChosen == true) {
                Player p =
                    Player(_playerListLocal[i].strPlayerName, "1", "1", "1");
                if (i <= midIndex) {
                  team1.add(p);
                } else {
                  team2.add(p);
                }
              }
            }

            if (team1.length < team2.length) {
              team1.add(team2.removeAt(0));
            }

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MatchScreen(team1, team2);
            }));
          }),
    );
  }
}
