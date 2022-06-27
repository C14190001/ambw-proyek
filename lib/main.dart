import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Parent());
}

class Parent extends StatelessWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: "Siklus (Login)", home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  List<Users> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siklus (Login)"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //Ambil data semua user -------------------
            StreamBuilder<QuerySnapshot>(
              stream: Database.getUsers(),
              builder: (context, snapshots) {
                if (snapshots.hasError) {
                  print("Error getting all users..");
                } else if (snapshots.hasData && snapshots.data != null) {
                  users.clear();
                  for (int i = 0; i < snapshots.data!.docs.length; i++) {
                    DocumentSnapshot ds = snapshots.data!.docs[i];
                    users.add(Users(
                        admin: ds['Admin'],
                        password: ds['Password'],
                        saldo: ds['Saldo'],
                        username: ds['Username']));
                  }
                  return const SizedBox();
                }
                return const SizedBox();
              },
            ),
            //-----------------------------------------
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                  labelText: "Username", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                for (int i = 0; i < users.length; i++) {
                  if (users[i].username == _username.text &&
                      users[i].password == _password.text) {
                    print("Login Success!");
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: ((context) {
                    //   return const Register();
                    // })));
                    break;
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                bool userExist = false;
                for (int i = 0; i < users.length; i++) {
                  if (users[i].username == _username.text &&
                      users[i].password == _password.text) {
                    userExist = true;
                    break;
                  }
                }

                if (!userExist) {
                  print("Register Success!");
                } else {
                  print("User already exist");
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
