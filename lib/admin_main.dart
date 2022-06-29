import 'package:ambw_proyek/admin_daftarReview.dart';
import 'package:ambw_proyek/admin_editProduk.dart';
import 'package:ambw_proyek/admin_status.dart';
import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class adminMain extends StatefulWidget {
  final String username;
  const adminMain({Key? key, required this.username}) : super(key: key);

  @override
  State<adminMain> createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  //int testProductTambah = 0;

  void snackbarFromDialog(String Message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(Message)));
  }

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
              ElevatedButton(
                  onPressed: () {
                    //testProductTambah++;

                    // Database.addProduct(
                    //     newProduct: Product(
                    //         Descriptions: "Test Product ${testProductTambah}",
                    //         Name: (testProductTambah).toString(),
                    //         PictureURL:
                    //             "https://12college.files.wordpress.com/2016/05/test-clip-art-cpa-school-test.png",
                    //         Price: "1",
                    //         Stock: "10"));

                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return adminEditProduk(
                        username: widget.username,
                      );
                    })));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Tambah Produk")),
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
                    //testProductTambah = snapshots.data!.docs.length;

                    return ListView.separated(
                        itemBuilder: ((context, index) {
                          DocumentSnapshot dsData = snapshots.data!.docs[index];

                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text(dsData['Name'])),
                                Text("Rp. " + dsData['Price'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))
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
                                      Text(
                                        "Stock: " + dsData['Stock'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      //Halaman Edit Produk
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: ((context) {
                                        return adminEditProduk(
                                          username: widget.username,
                                          editP: Product(
                                              Descriptions:
                                                  dsData['Descriptions'],
                                              Name: dsData['Name'],
                                              PictureURL: dsData['PictureURL'],
                                              Price: dsData['Price'],
                                              Stock: dsData['Stock']),
                                        );
                                      })));
                                    },
                                    child: const Icon(Icons.edit)),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title:
                                                    const Text("Hapus Produk"),
                                                content: Text(dsData['Name']),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Batal")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Database.deleteProduct(
                                                            productName:
                                                                dsData['Name']);
                                                        setState(() {});
                                                        snackbarFromDialog(
                                                            "Produk Dihapus!");
                                                      },
                                                      child:
                                                          const Text("Hapus"))
                                                ],
                                              ),
                                          barrierDismissible: false);
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
                  onPressed: () {
                    //Halaman Daftar Transaksi
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return const adminStatus();
                    })));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Daftar Transaksi")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return const adminReview();
                    })));
                  },
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
