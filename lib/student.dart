import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Student').snapshots(),
        builder: (context, studentSnapshot) {
          if (!studentSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> studentDocuments = studentSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Batch').snapshots(),
            builder: (context, batchSnapshot) {
              if (!batchSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot> batchDocuments = batchSnapshot.data!.docs;

              // Create a map to store batch data
              Map<String, String> batchMap = {};
              batchDocuments.forEach((batchDoc) {
                Map<String, dynamic> batchData =
                    batchDoc.data() as Map<String, dynamic>;
                batchMap[batchDoc.id] = batchData['BatchName'];
              });

              // Build the table using both student and batch data
              return DataTable(
                columns: [
                  DataColumn(label: Text('Student Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('DOB')),
                  DataColumn(label: Text('Batch Name')),
                ],
                rows: studentDocuments.map((studentDoc) {
                  Map<String, dynamic> studentData =
                      studentDoc.data() as Map<String, dynamic>;
                  String batchId = studentData['b_id_fk'];
                  String batchName = batchMap[batchId] ?? 'Unknown Batch';

                  return DataRow(cells: [
                    DataCell(Text(studentData['StudentName'] ?? '')),
                    DataCell(Text(studentData['Email'] ?? '')),
                    DataCell(Text(studentData['Address'] ?? '')),
                    DataCell(Text(studentData['DOB'] ?? '')),
                    DataCell(Text(batchName)),
                  ]);
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
