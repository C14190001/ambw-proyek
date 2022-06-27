import 'package:ambw_proyek/database_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class adminMain extends StatefulWidget {
  final String username;
  const adminMain({Key? key, required this.username}) : super(key: key);

  @override
  State<adminMain> createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Admin)",
      home: Scaffold(
        appBar: AppBar(title: const Text("Siklus (Admin)")),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Selamat datang ${widget.username}!",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 20),
                  )),
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
                                Text("Rp. " + dsData['Price'], style: const TextStyle(fontWeight: FontWeight.bold))
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
                                      Text("Stock: " + dsData['Stock'], style: const TextStyle(fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      //Edit Produk
                                    },
                                    child: const Icon(Icons.edit)),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      //Hapus Produk (Pake dialod are you sure)
                                    },
                                    child: const Text("X"))
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Daftar Transaksi")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Daftar Review")),
            ],
          ),
        ),
      ),
    );
  }
}
