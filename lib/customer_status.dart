import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class customerStatus extends StatefulWidget {
  final String username;
  const customerStatus({Key? key, required this.username}) : super(key: key);

  @override
  State<customerStatus> createState() => _customerStatusState();
}

class _customerStatusState extends State<customerStatus> {
  final TextEditingController _filter = TextEditingController();
  Stream<QuerySnapshot<Object?>> onSearch() {
    setState(() {});
    return Database.getAllStatusCustomer(
        username: widget.username, filter: _filter.text);
  }

  @override
  void initState() {
    _filter.addListener(onSearch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Customer - Status Transaksi)",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Siklus (Customer - Status Transaksi)"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _filter,
                decoration: const InputDecoration(
                    labelText: "Filter Produk", border: OutlineInputBorder()),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: onSearch(),
                  builder: (context, snapshots) {
                    if (snapshots.hasError) {
                      print(
                          "Error getting Customer ${widget.username} status..");
                      return Text(
                          "Gagal Memuat data Status Transaksi customer ${widget.username}");
                    } else if (snapshots.hasData) {
                      return ListView.separated(
                        itemBuilder: ((context, index) {
                          DocumentSnapshot dsData = snapshots.data!.docs[index];

                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    child: Text(dsData['ProductName'] +
                                        " (Rp. ${dsData["Price"]})")),
                                Text(
                                    "Total Rp. ${int.parse(dsData["Price"]) * int.parse(dsData["Stock"])}")
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                    child: Text("Stock: " + dsData['Stock'])),
                                Text("${dsData['Status']}")
                              ],
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: snapshots.data!.docs.length,
                      );
                    }
                    return Text(
                        "Memuat data Status Transaksi customer ${widget.username}");
                  },
                ),
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
