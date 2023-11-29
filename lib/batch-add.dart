import 'package:bid/batch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatchAdd extends StatefulWidget {
  @override
  _BatchAddState createState() => _BatchAddState();
}

class _BatchAddState extends State<BatchAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _batchName;
  late String _timings;
  late String _details;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batch Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Batch Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Batch name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _batchName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Timings'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter timings';
                  }
                  return null;
                },
                onSaved: (value) {
                  _timings = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Deatils'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
                onSaved: (value) {
                  _details = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Save data to Firestore including current date/time
                    await _firestore.collection('Batch').add({
                      'BatchName': _batchName,
                      'Timings': _timings,
                      'Details': _details,
                      'timestamp': DateTime.now(),
                    });

                    print("Inserted");

                    // Reset form after submission
                    _formKey.currentState!.reset();

                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BatchView()),
            );
                  }
                },
                child: Text('Submit'),
              ),

          //     IconButton(
          //   icon: Icon(Icons.people),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => BatchView()),
          //     );
          //   },
          // ),
            ],
          ),
        ),
      ),
    );
  }
}