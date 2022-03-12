import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/services/report_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class DescribeReason extends StatefulWidget {

  final String reason;
  final String? postId;

  const DescribeReason({ Key? key, required this.reason, required this.postId }) : super(key: key);

  @override
  _DescribeReasonState createState() => _DescribeReasonState();
}

class _DescribeReasonState extends State<DescribeReason> {

  ReportReq _reportReq = ReportReq();
  final _descTextController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(64),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorTheme.primary,
                        borderRadius: BorderRadius.circular(64)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0
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
                    'Describe the issue',
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  TextFormField(
                    controller: _descTextController,
                    cursorColor: ColorTheme.primary,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      // errorText: emailErrorText
                      hintText: 'type details here...'
                    ),
                    style: TextStyle(
                      fontSize: 16
                    ),
                    // validation
                    validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                    onChanged: (val) {
                    
                    },
                  ),
                ],
              ),
              SizedBox(height: 124.0,),
              Column(
                children: [
                  // Text(
                  //   'If you want to describe more about the issue you can send more details to this email.',
                  //   style: TextStyle(
                  //     fontSize: 16.0, 
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.normal
                  //   ),
                  // ),
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: 'If you want to describe more about the issue you can send more details to this email. gritie.contact@gmail.com',
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.3
                    ),
                    linkStyle: TextStyle(
                      color: ColorTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 32.0,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: ColorTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: () {
                        
                        _reportReq.reportPost(
                          reason: widget.reason,
                          description: _descTextController.text,
                          postId: widget.postId
                        ).whenComplete(() {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );

                        });
                  
                      }, 
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}