import 'package:flutter/material.dart';

class AddNewArt extends StatefulWidget {
  const AddNewArt({ Key? key }) : super(key: key);

  @override
  _AddNewArtState createState() => _AddNewArtState();
}

class _AddNewArtState extends State<AddNewArt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        elevation: 0,
        title: Text(
          'Add new art'
        ),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/placeholder-image.png'
          ),
          SizedBox(height: 4.0,),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_rounded,
                          color: Colors.black,
                          size: 28,
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          'Select Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffD8D8D8),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const AddNewArt()),
                    // );
                  }, 
                ),
                SizedBox(height: 8.0,),
                Text(
                  'Description', 
                  style: TextStyle(
                    fontSize: 18.0, 
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                ),
                TextFormField(
                  cursorColor: Colors.amber[700],
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: (Colors.amber[700])!)
                    ),
                    // errorText: emailErrorText
                    hintText: 'type description here...'
                  ),
                  style: TextStyle(
                    fontSize: 16
                  ),
                  // validation
                  validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                  onChanged: (val) {
                  
                  },
                ),
                SizedBox(height: 16.0,),
                Text(
                  'Tags  0/5', 
                  style: TextStyle(
                    fontSize: 18.0, 
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.amber[700],
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: (Colors.amber[700])!)
                              ),
                              // errorText: emailErrorText
                              hintText: 'type tags here...'
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
                        SizedBox(width: 8.0,),
                        IconButton(
                          icon: Icon(
                            Icons.add_box_rounded,
                            color: Colors.amber[600],
                          ),
                          onPressed: () {

                          }, 
                        )
                      ],
                    ),
                    SizedBox(height: 8.0,),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[600],
                            borderRadius: BorderRadius.circular(32)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0
                            ),
                            child: Text(
                              'gloweffect',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.0,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[600],
                            borderRadius: BorderRadius.circular(32)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0
                            ),
                            child: Text(
                              'gojo',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
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
                        'POST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const AddNewArt()),
                      // );
                    }, 
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}