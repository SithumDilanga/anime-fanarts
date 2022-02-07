import 'package:flutter/material.dart';

class ErrorLoading extends StatelessWidget {

  final String errorMsg;
  final Function onTryAgain;

  const ErrorLoading({ Key? key, required this.errorMsg, required this.onTryAgain }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$errorMsg',
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
            SizedBox(width: 8.0,),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.refresh_rounded
                ),
                onPressed: () {
                  onTryAgain();
                }, 
              ),
            )
          ],
        ),
      ),
    );
  }
}