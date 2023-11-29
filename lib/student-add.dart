import 'package:bid/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentAdd extends StatefulWidget {
  final String b_id_fk;
  // Constructor to receive input
  StudentAdd({required this.b_id_fk});
  @override
  _StudentAddState createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _StudentName;
  late String _email;
  late String _address;
  late String _dob;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Student name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _StudentName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ADDRESS'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date Of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter DOB';
                  }
                  return null;
                },
                onSaved: (value) {
                  _dob = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Save data to Firestore including current date/time
                    await _firestore.collection('Student').add({
                      'b_id_fk': widget.b_id_fk,
                      'StudentName': _StudentName,
                      'Email': _email,
                      'Address': _address,
                      'DOB': _dob,
                      'timestamp': DateTime.now(),
                    });

                    print("Inserted");

                    // Reset form after submission
                    _formKey.currentState!.reset();

                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentView()),
            );
                  }
                  else{
                    print("Error");
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