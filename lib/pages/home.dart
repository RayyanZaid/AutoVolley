import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stat/services/firebaseFunctions.dart';
import './addNewPlayer.dart';

class Home extends StatelessWidget {
  final AsyncSnapshot<User?> snapshot;

  const Home({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the snapshot here
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.leave_bags_at_home))
        ],
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'Hello ',
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              '${snapshot.data?.displayName}',
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Center(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AddNewPlayer(
                              uid: snapshot.data!.uid,
                            );
                          }));
                        },
                        child: Text('Add New Players'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200.0, 60.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Play Match'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200.0, 60.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('View Player Stats'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200.0, 60.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('View Account Info'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200.0, 60.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
