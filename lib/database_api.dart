import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ambw_proyek/dataclass.dart';

CollectionReference userTable = FirebaseFirestore.instance.collection("Users");

class Database{
  //Users
  static Stream<QuerySnapshot<Object?>> getUser(String username) {
    return userTable.where("Username",isEqualTo: username).snapshots();
  }

  static Future<void> addUser({required Users newUser}) async{
    DocumentReference dr = userTable.doc(newUser.username);
    await dr
      .set(newUser.toJson())
      .whenComplete(() => print("New User created!"))
      .catchError((e) => print(e));
  }

  static Future<void> editUser({required Users editedUser}) async{
    DocumentReference dr = userTable.doc(editedUser.username);
    await dr
      .update(editedUser.toJson())
      .whenComplete(() => print("User data edited!"))
      .catchError((e) => print(e));
  }

  static Future<void> deleteUser({required String username}) async {
    DocumentReference dr = userTable.doc(username);
    await dr
      .delete()
      .whenComplete(() => print("User deleted!"))
      .catchError((e) => print(e));
  }

}