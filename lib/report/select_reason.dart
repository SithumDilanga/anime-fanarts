import 'package:anime_fanarts/report/describe_reason.dart';
import 'package:flutter/material.dart';

class SelectReason extends StatefulWidget {
  const SelectReason({ Key? key }) : super(key: key);

  @override
  _SelectReasonState createState() => _SelectReasonState();
}

class _SelectReasonState extends State<SelectReason> {
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please select a reason',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 24,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Violence',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Violence')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Excessively sexual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Excessively sexual')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Copyright infringement',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Copyright infringement')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spam',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Spam')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Advertisement, promotion',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Advertisement, promotion')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Excessive grotesque content',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Excessive grotesque content')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Redistributed without permission',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Redistributed without permission')),
                );

              }, 
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Something else',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DescribeReason(reason: 'Something else')),
                );

              }, 
            ),
          ],
        ),
      ),
    );
  }
}