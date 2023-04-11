import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../classes/Player.dart';

class FirestoreServices {
  static saveUser(String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name});
  }

  static Future<void> deleteCollection(String uid) async {
    final collectionRef = FirebaseFirestore.instance.collection(uid);
    final batch = FirebaseFirestore.instance.batch();
    final querySnapshot = await collectionRef.get();

    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    await batch.commit();
    await collectionRef.doc().delete(); // Delete the empty collection
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

  static Future<Map<String, dynamic>> getListOfPlayers(String uid) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('players')
        .get();

    final Map<String, dynamic> playersMap = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final name = data['name'] as String;
      final playerData = {...data}
        ..remove('name'); // make a copy of the data and remove the 'name' field
      playersMap[name] =
          playerData; // add the data to the map using the name as the key
    }

    return playersMap;
  }

  static void updateWinsAndLosses(
      String uid, List<Player> winningTeam, List<Player> losingTeam) async {
    final userDocRef = FirebaseFirestore.instance.collection("users").doc(uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      for (final player in winningTeam) {
        final playerDocRef = userDocRef.collection("players").doc(player.name);
        DocumentSnapshot doc = await playerDocRef.get();
        final data = doc.data() as Map<String, dynamic>;
        int wins = data['wins'] + 1;
        int losses = data['losses'];

        double winPercentageUnrounded =
            ((wins * 1.0) / ((wins + losses) * 1.0));
        double winPercentage =
            double.parse(winPercentageUnrounded.toStringAsFixed(2));
        transaction.update(
            playerDocRef, {'wins': wins, 'winPercentage': winPercentage});

        debugPrint(wins.toString());
        debugPrint(losses.toString());
        debugPrint(winPercentage.toString());
      }

      for (final player in losingTeam) {
        final playerDocRef = userDocRef.collection("players").doc(player.name);
        DocumentSnapshot doc = await playerDocRef.get();
        final data = doc.data() as Map<String, dynamic>;
        int wins = data['wins'];
        int losses = data['losses'] + 1;

        double winPercentageUnrounded =
            ((wins * 1.0) / ((wins + losses) * 1.0));
        double winPercentage =
            double.parse(winPercentageUnrounded.toStringAsFixed(2));
        transaction.update(
            playerDocRef, {'losses': losses, 'winPercentage': winPercentage});

        debugPrint(wins.toString());
        debugPrint(losses.toString());
        debugPrint(winPercentage.toString());
      }
    });
  }
}
