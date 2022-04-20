import 'package:anime_fanarts/report/describe_reason.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';

class SelectUserReportReason extends StatefulWidget {

  final String? userId;

  const SelectUserReportReason({ Key? key, required this.userId }) : super(key: key);

  @override
  _SelectUserReportReasonState createState() => _SelectUserReportReasonState();
}

class _SelectUserReportReasonState extends State<SelectUserReportReason> {

  List<String> reasonList = [
    'Copyright infringement', 
    'Inappropriate works',
    'Inappropriate profile',
    'Guidance to Inappropriate websites',
    'Harassment',
    'Privacy infringement',
    'Posts equivalent to child abuse',
    'Something else'
  ];

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
          'Report this user'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                            postId: widget.userId,
                            reportType: 'userReport',
                          )
                        )
                      );
        
                    }, 
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}