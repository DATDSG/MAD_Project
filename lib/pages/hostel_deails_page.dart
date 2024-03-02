import 'package:flutter/material.dart';

class HostelDetailsPage extends StatefulWidget {
  const HostelDetailsPage({super.key});

  @override
  State<HostelDetailsPage> createState() => _HostelDetailsPageState();
}

class _HostelDetailsPageState extends State<HostelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Hostel Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}