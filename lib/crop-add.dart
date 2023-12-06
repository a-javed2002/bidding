import 'package:bid/common/loader.dart';
import 'package:bid/crop.dart';
import 'package:flutter/material.dart';
import 'package:bid/common/pop-up.dart';
import 'package:bid/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CropAdd extends StatefulWidget {
  @override
  _CropAddState createState() => _CropAddState();
}

class _CropAddState extends State<CropAdd> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  DateTime? _startAuctionDate;
  DateTime? _endAuctionDate;
  late TextEditingController _selectedRoleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _startAuctionDate = DateTime.now();
    _endAuctionDate = DateTime.now();
    _selectedRoleController = TextEditingController(text: '');

    // Set the initial value of _selectedRoleController
    _setSelectedRoleController();
  }

  // Set _selectedRoleController with the current user's ID
  void _setSelectedRoleController() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _selectedRoleController.text = user.uid;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _selectedRoleController.dispose();
    super.dispose();
  }

  Future<void> _insertCropData() async {
    try {
      setState(() {
        isLoading = true; // Set isLoading to true before signup
      });
      await FirebaseFirestore.instance.collection('crop').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'start_auct_date': _startAuctionDate!.toString(),
        'end_auct_date': _endAuctionDate!.toString(),
        'seller_id': _selectedRoleController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'bids': [],
        'feedback': {
          'highest_bidder_id': '',
          'comment': '',
          'timestamp': null,
        },
      });

        setState(() {
        isLoading = false; // Set isLoading to true before signup
      });

      print('Crop data inserted successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CropView()),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading to true before signup
      });
      print('Error inserting crop data: $e');
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startAuctionDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _startAuctionDate) {
      setState(() {
        _startAuctionDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endAuctionDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _endAuctionDate) {
      setState(() {
        _endAuctionDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Existing scaffold code...

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  // You can add additional validation for numeric values if needed
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Start Auction Date: '),
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(
                      _startAuctionDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('End Auction Date: '),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(
                      _endAuctionDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _selectedRoleController,
                decoration: InputDecoration(labelText: 'User ID'),
                enabled: false, // Disable editing
              ),
              Visibility(
              visible: isLoading,
              child: CustomLoader(), // Add your loader widget here
            ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Use the controller values in your signup logic
                    String name = _nameController.text;
                    String description = _descriptionController.text;
                    String price = _priceController.text;
                    String startAuctionDate = _startAuctionDate!.toString();
                    String endAuctionDate = _endAuctionDate!.toString();
                    String userID = _selectedRoleController.text;

                    _insertCropData();
                  }
                },
                child: Text('Add Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
