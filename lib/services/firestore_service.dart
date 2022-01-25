import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // feedbackLogic collection reference
  final CollectionReference ratingsCollection = FirebaseFirestore.instance.collection('feedbackLogic');

  // user postRating collection collection reference
  final CollectionReference userPostRatingCollection = FirebaseFirestore.instance.collection('postRating');

  // user feedbacks collection collection reference
  final CollectionReference userFeedbacksCollection = FirebaseFirestore.instance.collection('userFeedbacks');

  // user bug reporst collection collection reference
  final CollectionReference bugReporstCollection = FirebaseFirestore.instance.collection('bugReports');

  // ---------------- rating stuff --------------------

  Future<DocumentSnapshot> readIsRateAvailable() async {
    return await ratingsCollection.doc('FwMTVHArIGju4559XXKy').get();
  }

  Future sendUserRating(double rating, String uid) async {
    return await userPostRatingCollection.add({
      'rating': rating,
      'userId': uid
    });
  }

  // ---------------- End rating stuff --------------------

  // ------------------- get feedbacks -----------------

  Future sendUserFeedback(String feedbackText, String uid) async {
    return await userFeedbacksCollection.add({
      'rating': feedbackText,
      'userId': uid
    });
  }

  // ------------------- End get feedbacks -----------------

  // ------------------- get bug reports -----------------

  Future sendBugReports(String device, String andriodVersion,String desc, String uid) async {
    return await bugReporstCollection.add({
      'device': device,
      'andriodVersion': andriodVersion,
      'desc': desc,
      'userId': uid
    });
  }

  // ------------------- End get bug reports -----------------

}