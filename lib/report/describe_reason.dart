import 'package:flutter/material.dart';

class DescribeReason extends StatefulWidget {

  final String reason;

  const DescribeReason({ Key? key, required this.reason }) : super(key: key);

  @override
  _DescribeReasonState createState() => _DescribeReasonState();
}

class _DescribeReasonState extends State<DescribeReason> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text(
          'Report this art'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(64),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(64)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0
                  ),
                  child: Text(
                    '${widget.reason}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0,),
            Text(
              'Describe the issue'
            )
          ],
        ),
      ),
    );
  }
}