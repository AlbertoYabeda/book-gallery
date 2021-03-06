import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Firestore_Service {

  static Future<DocumentSnapshot> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userSnapshot;
  }

  static Future<void> addUser(uid, fullName, birthdate, email) async {
    var userData = {
      "fullName": fullName,
      "birthdate": birthdate,
      "email": email
    };
    FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
  }


  static Future<void> addBook(
      user_id,String title, String averageRating,String authores,
      String categories,String description, String thumbnail,String id,bool? isFavourite) async{

      final bookData = {
        "id" : id,
        "title" : title,
        "averageRating" : averageRating,
        "authors" : authores,
        "category" : categories,
        "description" : description,
        "thumbnail" : thumbnail,
        "isFavourite" : isFavourite
      };

      FirebaseFirestore.instance.collection('users')
          .doc(user_id)
          .collection("favouriteBooks")
          .add(bookData)
          .catchError((error) => throw Exception()
      );
  }

  static Future<QuerySnapshot> getFavouriteBooks(uid) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("favouriteBooks")
        .orderBy('title',descending: false)
        .get();
  }

  static Future<bool> getSingleBook(uid,bookID,bookTitle) async{
    bool bookAlreadySaved = false;
           await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection("favouriteBooks")
              .where('title', isEqualTo: bookTitle)
              .get().then((snapshot) {
                  snapshot.docs.forEach((element) {
                  bookAlreadySaved = element.exists;
                  //print(element['title']);
        });
      });
    return bookAlreadySaved;
}

  static Future<void> removeBookFromFavourite(uid,book) async{
      return await FirebaseFirestore.instance.collection("users").doc(uid)
           .collection("favouriteBooks").doc(book.id)
           .delete();
  }
}