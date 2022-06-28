import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class customerTopup extends StatefulWidget {
  final String username;
  const customerTopup({Key? key, required this.username}) : super(key: key);

  @override
  State<customerTopup> createState() => _customerTopupState();
}

class _customerTopupState extends State<customerTopup> {
  Users currentUser = Users(admin: "", password: "", saldo: "0", username: "0");
  final TextEditingController _topUp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Customer - TopUp Saldo)",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Siklus (Customer - TopUp Saldo)"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: Database.getUser(widget.username),
                builder: (context, snapshots) {
                  print("Getting user ${widget.username}..");
                  if (snapshots.hasError) {
                    print("Error getting user ${widget.username}!");
                  } else if (snapshots.hasData && snapshots.data != null) {
                    DocumentSnapshot ds = snapshots.data!.docs[0];
                    currentUser = Users(
                        admin: ds["Admin"],
                        password: ds["Password"],
                        saldo: ds["Saldo"],
                        username: ds["Username"]);
                    return Text(
                      "Saldo sekarang: Rp. ${ds["Saldo"]}",
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 20),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Masukkan jumlah saldo:"),
              Row(
                children: [
                  Text("Rp."),
                  Expanded(
                    child: TextField(
                      controller: _topUp,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Users edit = Users(
                        admin: currentUser.admin,
                        password: currentUser.password,
                        saldo: (int.parse(currentUser.saldo) +
                                int.parse(_topUp.text))
                            .toString(),
                        username: currentUser.username);
                    Database.editUser(editedUser: edit);
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("TopUp berhasil!"),
                              content: Text("Berhasil TopUp Rp.${_topUp.text}"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK")),
                              ],
                            ),
                        barrierDismissible: false);
                    _topUp.text = "";
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("TopUp Saldo")),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Kembali")),
            ],
          ),
        ),
      ),
    );
  }
}
