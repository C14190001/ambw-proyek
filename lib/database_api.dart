import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:flutter/widgets.dart';

CollectionReference userTable = FirebaseFirestore.instance.collection("Users");
CollectionReference productTable =
    FirebaseFirestore.instance.collection("Items");
CollectionReference CartTable = FirebaseFirestore.instance.collection("Cart");
CollectionReference reviewTable =
    FirebaseFirestore.instance.collection("Reviews");

class Database {
  //Users
  static Stream<QuerySnapshot<Object?>> getUsers() {
    return userTable.snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getUser(String username) {
    return userTable.where("Username", isEqualTo: username).snapshots();
  }

  static Future<void> addUser({required Users newUser}) async {
    DocumentReference dr = userTable.doc(newUser.username);
    await dr
        .set(newUser.toJson())
        .whenComplete(() => print("New User created!"))
        .catchError((e) => print(e));
  }

  static Future<void> editUser({required Users editedUser}) async {
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

  //Products
  static Stream<QuerySnapshot<Object?>> getAllProducts() {
    return productTable.snapshots();
  }

  static Future<void> addProduct({required Product newProduct}) async {
    DocumentReference dr = productTable.doc(newProduct.Name);
    await dr
        .set(newProduct.toJson())
        .whenComplete(() => print("New Product created!"))
        .catchError((e) => print(e));
  }

  static Future<void> editProduct({required Product editedProduct}) async {
    DocumentReference dr = productTable.doc(editedProduct.Name);
    await dr
        .update(editedProduct.toJson())
        .whenComplete(() => print("Product data edited!"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteProduct({required String productName}) async {
    DocumentReference dr = productTable.doc(productName);
    await dr
        .delete()
        .whenComplete(() => print("Product deleted!"))
        .catchError((e) => print(e));
  }

  //Cart
  static Stream<QuerySnapshot<Object?>> getAllCart() {
    return CartTable.snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getCart(String username) {
    return CartTable.where("Username", isEqualTo: username).snapshots();
  }

  static Future<void> addCart({required Cart newCart}) async {
    DocumentReference dr = CartTable.doc("${newCart.Username}_${newCart.Name}");
    await dr
        .set(newCart.toJson())
        .whenComplete(() => print("New Cart created!"))
        .catchError((e) => print(e));
  }

  static Future<void> editCart({required Cart editedCart}) async {
    DocumentReference dr =
        CartTable.doc("${editedCart.Username}_${editedCart.Name}");
    await dr
        .update(editedCart.toJson())
        .whenComplete(() => print("Cart data edited!"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteCart({required Cart deletedCart}) async {
    DocumentReference dr =
        productTable.doc("${deletedCart.Username}_${deletedCart.Name}");
    await dr
        .delete()
        .whenComplete(() => print("Cart deleted!"))
        .catchError((e) => print(e));
  }

  //Review
  static Stream<QuerySnapshot<Object?>> getAllReview() {
    return reviewTable.snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getReview(String username) {
    return reviewTable
        .orderBy("Username")
        .startAt([username]).endAt([username + '\uf8ff']).snapshots();
  }

  static Future<void> addReview(
      {required Reviews newReview, required int c}) async {
    DocumentReference dr = reviewTable.doc("${newReview.Username}_${c + 1}");
    await dr
        .set(newReview.toJson())
        .whenComplete(() => print("New Review created!"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteReview({required String id}) async {
    DocumentReference dr = reviewTable.doc(id);
    await dr
        .delete()
        .whenComplete(() => print("Review deleted!"))
        .catchError((e) => print(e));
  }
}
