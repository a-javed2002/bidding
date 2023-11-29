import 'package:bid/student-add.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BatchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batches'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Batch').snapshots(),
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
                title: Text("${data['BatchName']} --- ${data['Timings']}"),
                subtitle: Text(data['Details']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentAdd(b_id_fk: documents[index].id,)),
            );
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () {
                    //     FirebaseFirestore.instance
                    //         .collection('Employee')
                    //         .doc(documents[index].id)
                    //         .delete();
                    //   },
                    // ),
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
