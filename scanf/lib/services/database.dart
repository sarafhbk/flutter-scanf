import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  final String userId;
  final String collection;
  DataBase({required this.collection, required this.userId});

  Future<void> setData() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection(collection).doc(userId).set(
        {"in": FieldValue.arrayUnion([]), "out": FieldValue.arrayUnion([])});
  }

  Future<void> writeCheckIn({var timestamp}) async {
    final firestore = FirebaseFirestore.instance;
    var shouldCheckin = await _shouldCheckIn();
    if (shouldCheckin) {
      firestore.collection(collection).doc(userId).update({
        "in": FieldValue.arrayUnion([timestamp])
      }).then((value) => print("Success\n"));
    } else {
      firestore.collection(collection).doc(userId).update({
        "in": FieldValue.arrayUnion([timestamp]),
        "out": FieldValue.arrayUnion(["NA"])
      }).then((value) => print("Success\n"));
    }
  }

  Future<void> writeCheckOut({var timestamp}) async {
    final firestore = FirebaseFirestore.instance;
    var shouldCheckout = await _shouldCheckOut();
    if (shouldCheckout) {
      firestore.collection(collection).doc(userId).update({
        "out": FieldValue.arrayUnion([timestamp])
      }).then((value) => print("Success\n"));
    } else {
      firestore.collection(collection).doc(userId).update({
        "out": FieldValue.arrayUnion([timestamp]),
        "in": FieldValue.arrayUnion(["NA"])
      }).then((value) => print("Success\n"));
    }
  }

  Future<bool> _shouldCheckIn() async {
    final firestore = FirebaseFirestore.instance;

    var docSnapShot = await firestore.collection(collection).doc(userId).get();
    var response = docSnapShot.data();

    if (response!["in"].length == response["out"].length) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _shouldCheckOut() async {
    final firestore = FirebaseFirestore.instance;

    var docSnapShot = await firestore.collection(collection).doc(userId).get();
    var response = docSnapShot.data();

    if (response!["in"].length > response["out"].length) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> exists() async {
    bool exist = false;
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userId)
          .get()
          .then((docSnapShot) {
        exist = docSnapShot.exists;
      });
      return exist;
    } catch (e) {
      return false;
    }
  }

  Future<String> lastCheckIn() async {
    var docSnapShot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .get();
    var response = docSnapShot.data();
    if (response!["in"].length == 0) {
      return "";
    } else {
      return response["in"].last;
    }
  }

  Future<String> lastCheckOut() async {
    var docSnapShot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .get();
    var response = docSnapShot.data();
    if (response!["out"].length == 0) {
      return "";
    } else {
      return response["out"].last;
    }
  }
}
