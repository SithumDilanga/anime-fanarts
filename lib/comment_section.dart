import 'package:flutter/material.dart';

class CommentSecion extends StatefulWidget {
  const CommentSecion({ Key? key }) : super(key: key);

  @override
  _CommentSecionState createState() => _CommentSecionState();
}

class _CommentSecionState extends State<CommentSecion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // shape: Border(
        //   bottom: BorderSide(
        //     color: Colors.grey,
        //     width: 1,
        //   )
        // ),
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0
            ),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          ),
          preferredSize: Size.fromHeight(0.0)
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.amber,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.amber
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 4.0, right: 4.0, top: 4.0
        ),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blueGrey[700],
                          backgroundImage: NetworkImage(
                            'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          'Levi Ackerman',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.amber[700],
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: (Colors.amber[700])!)
                                ),
                                // errorText: emailErrorText
                                hintText: 'Leave a comment...'
                              ),
                              style: TextStyle(
                                fontSize: 16
                              ),
                              // validation
                              validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                              onChanged: (val) {
                                
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              size: 28,
                              color: Colors.amber,
                            ),
                            onPressed: () {
      
                            }, 
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                return Card(  
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blueGrey[700],
                                  backgroundImage: NetworkImage(
                                    'https://i.pinimg.com/736x/8e/de/53/8ede538fcf75a0a1bd812810edb50cb7.jpg'
                                  ),
                                ),
                                SizedBox(width: 8.0,),
                                Text(
                                  'Gojo Satoru',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                            Text(
                              'jan 15 8.32 p.m',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Phasellus porttitor accumsan dolor et laoreet. In nec tortor aliquet, fermentum mi ut, accumsan felis. Phasellus lobortis neque vel erat commodo consequat.'
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}