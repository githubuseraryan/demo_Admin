import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatelessWidget {

  final bool active;
 List orders = [];
  OrdersList({required this.active});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .orderBy('timeSec')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)  const CircularProgressIndicator();
if(snapshot.data!= null){
  orders = snapshot.data!.docs.where((doc) => doc['completed'] == !active).toList();


}

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total: \$${order['total']}'),
                  Text('Services: ${order['services']}'),
                  Text('Email: ${order['email']}'),
                  Text('Date: ${order['date']}'),
                  Text('Address: ${order['address']}'),
                  Text('Timestamp: ${order['timeSec']}'),
                ],
              ),
              trailing: active
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: Icon(Icons.delete),color: Colors.red,
                    onPressed: () => _deleteOrder(order.id,context),
                  ),
                  SizedBox(height: 20,),
                  IconButton(
                    icon: Icon(Icons.check_circle),color: Colors.green,
                    onPressed: () => _completeOrder(order.id),
                  ),
                ],
              )
                  : null,
            );
          },
        );
      },
    );
  }

  void _deleteOrder(String id, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Order'),
        content: Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('Orders').doc(id).delete();
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _completeOrder(String id) {
    FirebaseFirestore.instance.collection('Orders').doc(id).update({
      'completed': true,
      'timeSec': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
