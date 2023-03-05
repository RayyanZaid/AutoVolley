import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreServices {
  static saveUser(String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name});
  }

  static addNewPlayer(String name, uid) async {
    try {
      final playerDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('players')
          .doc(name);

      final playerDocSnapshot = await playerDoc.get();
      if (playerDocSnapshot.exists) {
        // Player already exists, handle accordingly
        debugPrint('$name already exists!');
        return true;
      } else {
        // Player does not exist, add them
        await playerDoc
            .set({'name': name, 'wins': 0, 'losses': 0, 'winPercentage': 0});
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return true;
    }
  }

  static getListOfPlayers(String uid) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('players')
        .get();

    final players = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data()
          as Map<String, dynamic>; // Cast data to Map<String, dynamic>
      players.add(data['name']); // Add the player name to the array
    }

    debugPrint(players.toString()); // Print the array of player names

    return players;
  }
}
