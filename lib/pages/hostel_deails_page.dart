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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 2,
        shadowColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Hostel Details',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
