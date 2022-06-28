import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class adminReview extends StatefulWidget {
  const adminReview({Key? key}) : super(key: key);

  @override
  State<adminReview> createState() => _adminReviewState();
}

class _adminReviewState extends State<adminReview> {
  final TextEditingController _filter = TextEditingController();

  Stream<QuerySnapshot<Object?>> getReview() {
    if (_filter.text.isEmpty) {
      return Database.getAllReview();
    } else {
      return Database.getReview(_filter.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Admin - Review)",
      home: Scaffold(
        appBar: AppBar(title: const Text("Siklus (Admin - Review)")),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _filter,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                    labelText: "Filter User", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: getReview(),
                    builder: (context, snapshots) {
                      if (snapshots.hasError) {
                      } else if (snapshots.hasData) {
                        print("ADMIN Get review");
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              DocumentSnapshot dsData =
                                  snapshots.data!.docs[index];
                              return ListTile(
                                title: Text(dsData['Username']),
                                subtitle: Row(children: [
                                  Expanded(child: Text(dsData['Review'])),
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      "Hapus Review ${dsData['Username']}?"),
                                                  content:
                                                      Text(dsData['Review']),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Batal")),
                                                    TextButton(
                                                        onPressed: () {
                                                          //DELETE REVIEW
                                                          Database.deleteReview(
                                                              id: snapshots
                                                                  .data!
                                                                  .docs[index]
                                                                  .id);
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("Hapus"))
                                                  ],
                                                ),
                                            barrierDismissible: false);
                                      },
                                      child: const Text("X"))
                                ]),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: snapshots.data!.docs.length);
                      }
                      return SizedBox();
                    }),
              ),
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
                  child: const Text("Kembali"))
            ],
          ),
        ),
      ),
    );
  }
}
