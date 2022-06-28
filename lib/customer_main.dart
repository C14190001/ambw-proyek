import 'package:ambw_proyek/customer_cart.dart';
import 'package:ambw_proyek/customer_review.dart';
import 'package:ambw_proyek/customer_topup.dart';
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
  List<Cart> currentCart = [];

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
                  //Ambil data cart ----------------
                  StreamBuilder<QuerySnapshot>(
                    stream: Database.getCart(widget.username),
                    builder: (context, snapshots) {
                      print("Getting cart from ${widget.username}..");
                      if (snapshots.hasError) {
                        print(
                            "Error getting card from user ${widget.username}!");
                      } else if (snapshots.hasData && snapshots.data != null) {
                        currentCart.clear();
                        for (int i = 0; i < snapshots.data!.docs.length; i++) {
                          DocumentSnapshot dsData = snapshots.data!.docs[i];
                          currentCart.add(Cart(
                              Name: dsData['Name'],
                              Username: dsData['Username'],
                              Price: dsData['Price'],
                              Stock: dsData['Stock']));
                        }
                      }
                      return SizedBox();
                    },
                  ),
                  //--------------------------------
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
                                      if (int.parse(currentUser.saldo) >=
                                          int.parse(dsData['Price'])) {
                                        if (int.parse(dsData['Stock']) <= 0) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        "Gagal tambah ke keranjang"),
                                                    content: const Text(
                                                        "Stock produk habis!"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text("OK"))
                                                    ],
                                                  ),
                                              barrierDismissible: false);
                                        } else {
                                          //Check jika sdh ada
                                          bool f = false;
                                          Cart c = Cart(
                                              Name: "",
                                              Username: "",
                                              Price: "0",
                                              Stock: "0");
                                          for (int i = 0;
                                              i < currentCart.length;
                                              i++) {
                                            if ("${currentCart[i].Username}_${currentCart[i].Name}" ==
                                                "${currentUser.username}_" +
                                                    dsData['Name']) {
                                              f = true;
                                              c = Cart(
                                                  Name: dsData['Name'],
                                                  Username:
                                                      currentUser.username,
                                                  Price: dsData['Price'],
                                                  Stock: (int.parse(
                                                              currentCart[i]
                                                                  .Stock) +
                                                          1)
                                                      .toString());
                                              break;
                                            }
                                          }

                                          if (f) {
                                            //Tambah stock Cart
                                            Database.editCart(editedCart: c);
                                          } else {
                                            //Buat Cart baru
                                            Database.addCart(
                                                newCart: Cart(
                                                    Name: dsData['Name'],
                                                    Username:
                                                        currentUser.username,
                                                    Price: dsData['Price'],
                                                    Stock: "1"));
                                          }

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Berhasil tambahkan ke keranjang!')));

                                          int s = int.parse(dsData['Stock']);
                                          s--;
                                          Product p = Product(
                                              Descriptions:
                                                  dsData['Descriptions'],
                                              Name: dsData['Name'],
                                              PictureURL: dsData['PictureURL'],
                                              Price: dsData['Price'],
                                              Stock: s.toString());
                                          Database.editProduct(
                                              editedProduct: p);
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Gagal tambah ke keranjang"),
                                                  content: const Text(
                                                      "Saldo tidak mencukupi!"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text("OK"))
                                                  ],
                                                ),
                                            barrierDismissible: false);
                                      }
                                    },
                                    child: const Icon(
                                        Icons.shopping_cart_outlined))
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return customerCart(
                              username: currentUser.username,
                            );
                          })));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text("Keranjang Saya")),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          //HALAMAN customer_status.dart
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text("Status Transaksi")),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return customerTopup(
                              username: currentUser.username,
                            );
                          })));
                        },
                        child: const Text("TopUp Saldo")),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return customerReview(
                              username: currentUser.username,
                            );
                          })));
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
