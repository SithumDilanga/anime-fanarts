import 'package:anime_fanarts/models/profile_user.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBio extends StatefulWidget {

  final String bioText;
  final String? uid;

  const EditBio({ Key? key, required this.bioText, required this.uid }) : super(key: key);

  @override
  _EditBioState createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  
  String updatedBioText = '';

  ProfileReq _profileReq = ProfileReq();

  @override
  Widget build(BuildContext context) {

    var profileData = Provider.of<ProfileUser>(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.primary,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Edit Your Bio', 
                    style: TextStyle(
                      fontSize: 20.0, 
                      color: Colors.grey
                    ),
                  ),
                  TextFormField(
                    // controller: _bioText,
                    initialValue: widget.bioText,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 500,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (text) {
                      // _bioText.text = text;
                      updatedBioText = text;
                    },
                  ),
                  SizedBox(height: 16.0,),
                  ElevatedButton(
                    child: Text(
                      'Update', 
                      style: TextStyle(
                        fontSize: 16.0, 
                        color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ColorTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                      ),
                      padding: EdgeInsets.fromLTRB(66.0, 16.0, 66.0, 16.0),
                    ),
                    onPressed: () {
                
                      if(updatedBioText.isEmpty) {
                
                        Navigator.pop(context);
                
                      } else {
                
                        _profileReq.updateBio(updatedBioText).whenComplete(() => {
                          profileData.updateBio(updatedBioText),
                          Navigator.pop(context)
                        });
                
                      }
                
                
                    }, 
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}