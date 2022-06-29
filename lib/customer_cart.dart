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
  Users currentUser = Users(admin: "", password: "", saldo: "0", username: "");
  List<Product> allProduct = [];
  List<Cart> allCart = [];

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
              //Ambil data semua produk -------------------------
              StreamBuilder<QuerySnapshot>(
                stream: Database.getAllProducts(),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    print("Error getting all product..");
                  } else if (snapshots.hasData) {
                    print("Getting all product..");
                    allProduct.clear();
                    for (int i = 0; i < snapshots.data!.docs.length; i++) {
                      DocumentSnapshot dsData = snapshots.data!.docs[i];
                      allProduct.add(Product(
                          Descriptions: dsData['Descriptions'],
                          Name: dsData['Name'],
                          PictureURL: dsData['PictureURL'],
                          Price: dsData['Price'],
                          Stock: dsData['Stock']));
                    }
                  }
                  return const SizedBox();
                },
              ),
              //-------------------------------------------------
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
                        if (snapshots.hasError) {
                          return const Text("Gagal ambil data keranjang saya!");
                        } else if (snapshots.hasData) {
                          print("Getting ${widget.username} cart..");
                          allCart.clear();
                          for (int i = 0;
                              i < snapshots.data!.docs.length;
                              i++) {
                            DocumentSnapshot ds = snapshots.data!.docs[i];
                            allCart.add(Cart(
                                Name: ds['Name'],
                                Username: ds['Username'],
                                Price: ds['Price'],
                                Stock: ds['Stock']));
                          }

                          return ListView.separated(
                              itemBuilder: ((context, index) {
                                DocumentSnapshot dsData =
                                    snapshots.data!.docs[index];

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
                                                                  String
                                                                      returnStock =
                                                                      dsData[
                                                                          'Stock'];
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

                                                                  //Refund stock yang ada di Cart
                                                                  Product x = allProduct
                                                                      .singleWhere((e) =>
                                                                          e.Name ==
                                                                          dsData[
                                                                              'Name']);

                                                                  Database.editProduct(
                                                                      editedProduct: Product(
                                                                          Descriptions: x
                                                                              .Descriptions,
                                                                          Name: dsData[
                                                                              'Name'],
                                                                          PictureURL: x
                                                                              .PictureURL,
                                                                          Price: dsData[
                                                                              'Price'],
                                                                          Stock:
                                                                              (int.parse(x.Stock) + int.parse(returnStock)).toString()));
                                                                  setState(
                                                                      () {});
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
              //Ambil Total Harga ----------------------------
              StreamBuilder<QuerySnapshot>(
                  stream: Database.getCart(widget.username),
                  builder: (context, snapshots) {
                    if (snapshots.hasError) {
                      return const Text("Gagal ambil data keranjang saya!");
                    } else if (snapshots.hasData) {
                      print("Getting ${widget.username} cart TOTAL PRICE..");
                      totalHarga = 0;
                      for (int i = 0; i < snapshots.data!.docs.length; i++) {
                        DocumentSnapshot dsData = snapshots.data!.docs[i];
                        totalHarga += (int.parse(dsData['Price']) *
                            int.parse(dsData['Stock']));
                      }
                      return Text(
                        "Total pesanan: Rp. $totalHarga",
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      );
                    }
                    return const Text("Memuat Keranjang Saya");
                  }),
              //----------------------------------------------
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
                    currentUser = Users(
                        admin: ds['Admin'],
                        password: ds['Password'],
                        saldo: ds['Saldo'],
                        username: ds['Username']);

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
                    if (allCart.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: const Text("Order Semua gagal!"),
                                  content: const Text(
                                      "Tidak ada produk dalam keranjang!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK")),
                                  ]));
                    } else if (totalHarga > int.parse(currentUser.saldo)) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Order Gagal"),
                                content: const Text("Saldo tidak mencukupi!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"))
                                ],
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text("Order semua pesanan?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Batal")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        int m = int.parse(currentUser.saldo) -
                                            totalHarga;
                                        Database.editUser(
                                            editedUser: Users(
                                                admin: currentUser.admin,
                                                password: currentUser.password,
                                                saldo: m.toString(),
                                                username:
                                                    currentUser.username));

                                        //-----------------------------------------------------------
                                        //Pindah semua pesanan ke Status
                                        //Data CART ada di allCart (List)
                                        //Status add semua yg ada di Cart
                                        //Loop FOR database.deleteCart dg data CART per index

                                        //BUG: Kalau order item yang sama akan error karena pake
                                        //Database AddStatus, perlu tambahkan kode untuk cek jika
                                        //sudah ada pesanan sebelumnya. Kalau ada, maka buat dengan
                                        //ID customerName_productName_1 (ditambah angka)

                                        for (int i = 0;
                                            i < allCart.length;
                                            i++) {
                                          Database.addStatus(
                                              newStatus: Statuses(
                                                  Price: allCart[i].Price,
                                                  ProductName: allCart[i].Name,
                                                  Status: "Proccess",
                                                  Stock: allCart[i].Stock,
                                                  Username:
                                                      currentUser.username));

                                          Database.deleteCart(
                                              deletedCart: Cart(
                                                  Name: allCart[i].Name,
                                                  Username: allCart[i].Username,
                                                  Price: allCart[i].Price,
                                                  Stock: allCart[i].Stock));
                                        }
                                        //-----------------------------------------------------------

                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Order Behasil"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("OK")),
                                                  ],
                                                ),
                                            barrierDismissible: false);
                                      },
                                      child: const Text("PESAN")),
                                ],
                              ),
                          barrierDismissible: false);
                    }
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
