import 'package:flutter/material.dart';
import 'dart:convert';
import "../classes/Player.dart";
import "./playerStats.dart";
import 'dart:math';
import "../services/firebaseFunctions.dart";

class MatchScreen extends StatefulWidget {
  final List<Player> team1;
  final List<Player> team2;
  final String uid;
  MatchScreen(this.team1, this.team2, this.uid);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      sender,
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(
      body,
      style: TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    );
  }
}

class _MatchScreenState extends State<MatchScreen> {
  List<Player> team1 = [];
  List<Player> team2 = [];
  String uid = "";
  @override
  void initState() {
    super.initState();
    team1 = widget.team1;
    team2 = widget.team2;
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> teams = [];
    teams.add(HeadingItem("After each game, select which team won"));

    teams.add(HeadingItem(''));

    teams.add(HeadingItem(''));

    for (int i = 0; i < team1.length; i++) {
      String eachName = team1[i].name;
      double unrounded = double.parse(team1[i].wps) * 100;
      // String winP = ('Win%: ' + unrounded.roundToDouble().toString() + "%");
      String winP = "";
      teams.add(MessageItem(eachName, winP));
    }

    teams.add(HeadingItem(''));
    teams.add(HeadingItem(''));

    teams.add(HeadingItem(''));

    for (int i = 0; i < team2.length; i++) {
      String eachName = team2[i].name;
      double unrounded = double.parse(team2[i].wps) * 100;
      // String winP = ('Win%: ' + unrounded.roundToDouble().toString() + "%");
      String winP = "";
      teams.add(MessageItem(eachName, winP));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 15, 174, 227),
          title: Text('Match Screen'),
          leading: FlatButton(
            textColor: Colors.black,
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerStats(playerList: team1 + team2);
            })),
            child: Icon(
              Icons.home,
            ),
          ),
          actions: <Widget>[],
        ),
        body: Container(
            child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: teams.length,
          itemBuilder: (BuildContext context, int index) {
            final player = teams[index];
            if (index == 2) {
              return Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        FirestoreServices.updateWinsAndLosses(
                            uid, team1, team2);
                      },
                      icon: Icon(
                        Icons.ads_click_rounded,
                      ),
                      label: Text(
                        "Team 1",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 60, 186, 232),
                      )));
            }

            if (index == team1.length + 5) {
              return Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        FirestoreServices.updateWinsAndLosses(
                            uid, team2, team1);
                      },
                      icon: Icon(
                        Icons.ads_click_rounded,
                      ),
                      label: Text(
                        "Team 2",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 227, 27, 20),
                      )));
            }
            return ListTile(
              title: player.buildTitle(context),
              subtitle: player.buildSubtitle(context),
            );
          },
        )),
        bottomNavigationBar: ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.ads_click_rounded,
            ),
            label: Text(
              "Switch Teams",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(280, 80),
              textStyle: TextStyle(fontSize: 28),
              padding: EdgeInsets.only(top: 30, bottom: 30),
              backgroundColor: Color.fromARGB(255, 21, 177, 47),
            )));
  }

  void _showDialog(
      BuildContext context, var message, var alert, Color bgColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: new Text(alert),
          content: new Text(message),
          actions: <Widget>[
            new TextButton(
              child: new Text("OK", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
