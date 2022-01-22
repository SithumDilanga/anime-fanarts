import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // feedbackLogic collection reference
  final CollectionReference ratingsCollection = FirebaseFirestore.instance.collection('feedbackLogic');

  // user feedbacks collection collection reference
  final CollectionReference userFeedbacksCollection = FirebaseFirestore.instance.collection('userFeedbacks');

  // ---------------- rating stuff --------------------

  Future<DocumentSnapshot> readIsRateAvailable() async {
    return await ratingsCollection.doc('FwMTVHArIGju4559XXKy').get();
  }

  Future sendUserRating(double rating, String uid) async {
    return await userFeedbacksCollection.add({
      'rating': rating,
      'userId': uid
    });
  }

  // ---------------- End rating stuff --------------------

}