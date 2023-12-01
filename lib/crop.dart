import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CropView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop View'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('crop').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text("${data['name']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description: ${data['description']}"),
                    Text("Price: ${data['price']}"),
                    Text("Start Auction Date: ${data['start_auct_date']}"),
                    Text("End Auction Date: ${data['end_auct_date']}"),
                    Text("User ID: ${data['user_id']}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.panorama_fish_eye),
                      onPressed: () {
                        // Add any action you want when the eye icon is pressed
                      },
                    ),
                    // Add more IconButton widgets for other actions
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
