import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'OrdersList.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Orders'),
              Tab(text: 'Completed Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrdersList(active: true),
            OrdersList(active: false),
          ],
        ),
      ),
    );
  }
}