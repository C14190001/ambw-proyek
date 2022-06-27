import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class customerMain extends StatefulWidget {
  final String username;
  const customerMain({Key? key, required this.username}) : super(key: key);

  @override
  State<customerMain> createState() => _customerMainState();
}

class _customerMainState extends State<customerMain> {
  late Users currentUser;
  String saldo = "...";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Customer)",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Siklus (Customer)"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                        //Ambil data user ----------------
                        StreamBuilder<QuerySnapshot>(
                      stream: Database.getUser(widget.username),
                      builder: (context, snapshots) {
                        print("Getting user ${widget.username}..");
                        if (snapshots.hasError) {
                          print("Error getting user ${widget.username}!");
                        } else if (snapshots.hasData &&
                            snapshots.data != null) {
                          DocumentSnapshot ds = snapshots.data!.docs[0];
                          currentUser = Users(
                              admin: ds["Admin"],
                              password: ds["Password"],
                              saldo: ds["Saldo"],
                              username: ds["Username"]);
                          return Text(
                            "Selamat datang ${ds["Username"]}!\nSaldo: Rp. ${ds["Saldo"]}",
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 20),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    //--------------------------------
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Logout"))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Daftar produk"),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: Database.getAllProducts(),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return const Text("Gagal ambil data semua produk!");
                  } else if (snapshots.hasData) {
                    return ListView.separated(
                        itemBuilder: ((context, index) {
                          DocumentSnapshot dsData = snapshots.data!.docs[index];

                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text(dsData['Name'])),
                                Text("Rp. " + dsData['Price'],style: const TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(dsData['Descriptions']),
                                      Text("Stock: " + dsData['Stock'],style: const TextStyle(fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      //TAMBAHKAN KE KERANJANG
                                      //Cek Stock (produk - 1)
                                      //Snakcbar berhasil tambah di keranjang + Stock produk - 1
                                    },
                                    child: const Icon(Icons.shopping_cart_outlined))
                              ],
                            ),
                            leading: Image(
                              image: NetworkImage(dsData['PictureURL']),
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: snapshots.data!.docs.length);
                  }
                  return const Text(
                    "Memuat daftar produk..",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  );
                },
              )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    //HALAMAN customer_cart.dart
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Keranjang Saya")),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          //HALAMAN customer_topup.dart
                        },
                        
                        child: const Text("TopUp Saldo")),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          //HALAMAN customer_review.dart
                        },
                        
                        child: const Text("Review Aplikasi")),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
