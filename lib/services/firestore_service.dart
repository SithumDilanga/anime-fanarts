import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreService {

  // feedbackLogic collection reference
  final CollectionReference ratingsCollection = FirebaseFirestore.instance.collection('feedbackLogic');

  // user postRating collection collection reference
  final CollectionReference userPostRatingCollection = FirebaseFirestore.instance.collection('postRating');

  // user feedbacks collection collection reference
  final CollectionReference userFeedbacksCollection = FirebaseFirestore.instance.collection('userFeedbacks');

  // user bug reporst collection collection reference
  final CollectionReference bugReporstCollection = FirebaseFirestore.instance.collection('bugReports');

  // user reports collection collection reference
  final CollectionReference userReportstCollection = FirebaseFirestore.instance.collection('userReports');

  // ---------------- rating stuff --------------------

  Future<DocumentSnapshot> readIsRateAvailable() async {
    return await ratingsCollection.doc('FwMTVHArIGju4559XXKy').get();
  }

  Future sendUserRating(double rating, String uid) async {
    return await userPostRatingCollection.add({
      'rating': rating,
      'userId': uid,
      'time': FieldValue.serverTimestamp()
    });
  }

  // ---------------- End rating stuff --------------------

  // ------------------- get feedbacks -----------------

  Future sendUserFeedback(String feedbackText, String uid) async {
    return await userFeedbacksCollection.add({
      'feedback': feedbackText,
      'userId': uid,
      'time': FieldValue.serverTimestamp()
    });
  }

  // ------------------- End get feedbacks -----------------

  // ------------------- get bug reports -----------------

  Future sendBugReports(String device, String andriodVersion,String desc, String uid) async {
    return await bugReporstCollection.add({
      'device': device,
      'andriodVersion': andriodVersion,
      'desc': desc,
      'userId': uid,
      'time': FieldValue.serverTimestamp()
    });
  }

  // ------------------- End get bug reports -----------------

  // ------------------- get user reports -----------------

  Future sendUserReport({String? reason, String? description, String? userId}) async {

    try {

      return await userReportstCollection.add({
        'reason': reason,
        'description': description,
        'userId': userId,
        'time': FieldValue.serverTimestamp()
      }).whenComplete(() {

        Fluttertoast.showToast(
          msg: 'your report has been submitted!',
          toastLength: Toast.LENGTH_LONG,
        );

      });

    } catch(e) {

      Fluttertoast.showToast(
        msg: 'Error reporting user!',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    
  }

  // ------------------- End get user reports -----------------

}