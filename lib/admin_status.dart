import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class adminStatus extends StatefulWidget {
  const adminStatus({Key? key}) : super(key: key);

  @override
  State<adminStatus> createState() => _adminStatusState();
}

class _adminStatusState extends State<adminStatus> {
  final TextEditingController _filter = TextEditingController();
  Stream<QuerySnapshot<Object?>> onSearch() {
    setState(() {});
    return Database.getAllStatusAdmin(_filter.text);
  }

  void dropValueReselect(String newValue) {}

  @override
  void initState() {
    _filter.addListener(onSearch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Admin - Status Transaksi)",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Siklus (Admin - Status Transaksi)"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _filter,
                decoration: const InputDecoration(
                    labelText: "Filter User", border: OutlineInputBorder()),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: onSearch(),
                  builder: (context, snapshots) {
                    if (snapshots.hasError) {
                      print("Error getting Status..");
                      return const Text("Gagal Memuat data Status Transaksi");
                    } else if (snapshots.hasData) {
                      return ListView.separated(
                        itemBuilder: ((context, index) {
                          DocumentSnapshot dsData = snapshots.data!.docs[index];

                          return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    dsData['Username'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Text(
                                      "Total Rp. ${int.parse(dsData["Price"]) * int.parse(dsData["Stock"])}")
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          "${dsData['Stock']}x ${dsData['ProductName']} (Rp. ${dsData['Price']})")),
                                  Text("${dsData['Status']}")
                                ],
                              ),
                              leading: ElevatedButton(
                                onPressed: () {
                                  String dropValue = dsData['Status'];

                                  showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setState) {
                                            return AlertDialog(
                                              title: const Text("Edit Status"),
                                              content: Row(
                                                children: [
                                                  const Expanded(
                                                      child: Text(
                                                          "Status pesanan")),
                                                  DropdownButton(
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: "Proccess",
                                                          child:
                                                              Text("Proccess"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "Shipping",
                                                          child:
                                                              Text("Shipping"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "Done",
                                                          child: Text("Done"),
                                                        ),
                                                      ],
                                                      value: dropValue,
                                                      onChanged:
                                                          (String? select) {
                                                        setState(() {
                                                          dropValue = select!;
                                                        });
                                                      })
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Batal")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      Database.editStatus(
                                                          editedStatus: Statuses(
                                                              Price: dsData[
                                                                  'Price'],
                                                              ProductName: dsData[
                                                                  'ProductName'],
                                                              Status: dropValue,
                                                              Stock: dsData[
                                                                  'Stock'],
                                                              Username: dsData[
                                                                  'Username']),
                                                          id: dsData.id);

                                                      // Database.editStatus(
                                                      //     editedStatus: Statuses(
                                                      //         Price: dsData[
                                                      //             'Price'],
                                                      //         ProductName: dsData[
                                                      //             'ProductName'],
                                                      //         Status: dropValue,
                                                      //         Stock: dsData[
                                                      //             'Stock'],
                                                      //         Username: dsData[
                                                      //             'Username']));

                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        "Edit Status berhasil!"),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text("OK"))
                                                                    ],
                                                                  ));
                                                    },
                                                    child: const Text("OK")),
                                              ],
                                            );
                                          }),
                                      barrierDismissible: false);
                                },
                                child: const Icon(Icons.edit),
                              ),
                              trailing: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Hapus Status?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Batal")),
                                                TextButton(
                                                    onPressed: () {
                                                      // Database.deleteStatus(
                                                      //     Username: dsData[
                                                      //         'Username'],
                                                      //     ProductName: dsData[
                                                      //         'ProductName']);

                                                      Database.deleteStatus(
                                                          id: dsData.id);

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("OK")),
                                              ],
                                            ));
                                  },
                                  child: Text("X")));
                        }),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: snapshots.data!.docs.length,
                      );
                    }
                    return const Text("Memuat data Status Transaksi customer");
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
