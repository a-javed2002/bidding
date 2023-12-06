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
              return CropListItem(
                name: data['name'],
                price: data['price'],
                startAuctionDate: data['start_auct_date'],
                endAuctionDate: data['end_auct_date'],
                onTap: () {
                  // Navigate to the detailed page with the selected crop item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CropDetailPage(data: data),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CropListItem extends StatelessWidget {
  final String name;
  final double price;
  final String startAuctionDate;
  final String endAuctionDate;
  final VoidCallback onTap;

  CropListItem({
    required this.name,
    required this.price,
    required this.startAuctionDate,
    required this.endAuctionDate,
    required this.onTap,
  });

  String getStatus() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime.parse(startAuctionDate);
    DateTime endDate = DateTime.parse(endAuctionDate);

    if (currentDate.isBefore(startDate)) {
      return "Upcoming";
    } else if (currentDate.isBefore(endDate)) {
      return "Live Bid";
    } else {
      return "Ended";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price: $price"),
          Text("Start Auction Date: $startAuctionDate"),
          Text("End Auction Date: $endAuctionDate"),
          Text("Status: ${getStatus()}"),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.panorama_fish_eye),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class CropDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  CropDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    // Implement your detailed page UI using the 'data'
    // Example: Access data['name'], data['price'], etc.
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Price: ${data['price']}"),
            Text("Start Auction Date: ${data['start_auct_date']}"),
            Text("End Auction Date: ${data['end_auct_date']}"),
            Text("Status: ${CropListItem().getStatus()}"),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
