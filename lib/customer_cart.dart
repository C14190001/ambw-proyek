import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class customerCart extends StatefulWidget {
  final String username;
  const customerCart({Key? key, required this.username}) : super(key: key);

  @override
  State<customerCart> createState() => _customerCartState();
}

class _customerCartState extends State<customerCart> {
  int totalHarga = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Customer - Keranjang Saya",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Siklus (Customer - Keranjang Saya)"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Daftar Keranjang Saya:",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Database.getCart(widget.username),
                      builder: (context, snapshots) {
                        totalHarga = 0;
                        if (snapshots.hasError) {
                          return const Text("Gagal ambil data keranjang saya!");
                        } else if (snapshots.hasData) {
                          return ListView.separated(
                              itemBuilder: ((context, index) {
                                DocumentSnapshot dsData =
                                    snapshots.data!.docs[index];

                                totalHarga += (int.parse(dsData['Price']) *
                                    int.parse(dsData['Stock']));
                                return ListTile(
                                  title: Row(children: [
                                    Expanded(
                                      child: Text(dsData['Name'] +
                                          " (Rp. ${dsData['Price']})"),
                                    ),
                                    Text(
                                        " Total Rp. ${int.parse(dsData['Price']) * int.parse(dsData['Stock'])}")
                                  ]),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              "Stock: ${dsData['Stock']}")),
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: const Text(
                                                              "Hapus produk"),
                                                          content: Text(
                                                              "Hapus ${dsData['Name']}?"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                    "Batal")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Database.deleteCart(
                                                                      deletedCart: Cart(
                                                                          Name: dsData[
                                                                              'Name'],
                                                                          Username: dsData[
                                                                              'Username'],
                                                                          Price: dsData[
                                                                              'Price'],
                                                                          Stock:
                                                                              dsData['Stock']));
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Hapus"))
                                                          ],
                                                        ),
                                                barrierDismissible: false);
                                          },
                                          child: const Text("X"))
                                    ],
                                  ),
                                );
                              }),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: snapshots.data!.docs.length);
                        }
                        return const Text("Memuat Keranjang Saya");
                      })),
              Text(
                "Total pesanan: Rp. $totalHarga",
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Database.getUser(widget.username),
                builder: (context, snapshots) {
                  print("Getting user ${widget.username}..");
                  if (snapshots.hasError) {
                    print("Error getting user ${widget.username}!");
                  } else if (snapshots.hasData && snapshots.data != null) {
                    DocumentSnapshot ds = snapshots.data!.docs[0];
                    return Text(
                      "Saldo sekarang: Rp. ${ds["Saldo"]}",
                      style: const TextStyle(fontSize: 20),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    //Saldo sekarang - Total pesanan
                    //Pindah semua pesanan ke Status
                    //Dialog "Pesanan berhasil dibuat!"
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Order Semua")),
              const SizedBox(
                height: 20,
              ),
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
