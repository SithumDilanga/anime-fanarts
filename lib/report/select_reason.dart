import 'package:anime_fanarts/report/describe_reason.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';

class SelectReason extends StatefulWidget {

  final String? postId;

  const SelectReason({ Key? key, required this.postId }) : super(key: key);

  @override
  _SelectReasonState createState() => _SelectReasonState();
}

class _SelectReasonState extends State<SelectReason> {

  List<String> reasonList = ['Violence', 'Excessively sexual', 'Copyright infringement', 'Spam', 'Advertisement, promotion', 'Excessive grotesque content', 'Redistributed without permission', 'Something else'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
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

            for(String reason in reasonList)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$reason',
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
                    primary: ColorTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {

                    Navigator.of(context).push(
                      RouteTransAnim().createRoute(
                        1.0, 0.0, 
                        DescribeReason(
                          reason: '$reason',
                          postId: widget.postId,
                        )
                      )
                    );

                  }, 
                ),
              ),
          ],
        ),
      ),
    );
  }
}