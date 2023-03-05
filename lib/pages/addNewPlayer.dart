import 'package:flutter/material.dart';
import 'package:stat/services/firebaseFunctions.dart';

class AddNewPlayer extends StatefulWidget {
  final String uid;

  AddNewPlayer({required this.uid});

  @override
  _AddNewPlayerState createState() => _AddNewPlayerState();
}

class _AddNewPlayerState extends State<AddNewPlayer> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Player"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                bool nameExists =
                    await FirestoreServices.addNewPlayer(name, widget.uid);

                if (nameExists) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Name Already Exists'),
                        content: Text(
                            'The name ${name} is taken. Please choose another.'),
                        backgroundColor: Color.fromARGB(255, 230, 128, 128),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success!'),
                        content: Text('${name} has been added to the database'),
                        backgroundColor: Color.fromARGB(255, 51, 165, 70),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }

                await FirestoreServices.getListOfPlayers(widget.uid);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
