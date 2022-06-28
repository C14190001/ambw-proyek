import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class customerReview extends StatefulWidget {
  final String username;
  const customerReview({Key? key, required this.username}) : super(key: key);

  @override
  State<customerReview> createState() => _customerReviewState();
}

class _customerReviewState extends State<customerReview> {
  final TextEditingController _review = TextEditingController();
  int c = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Customer - Review)",
      home: Scaffold(
        appBar: AppBar(title: const Text("Siklus (Customer - Review)")),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              //Ambil banyak review  -----

              StreamBuilder<QuerySnapshot>(
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                  } else if (snapshots.hasData) {
                    print("Get banyak review");
                    c = snapshots.data!.docs.length;
                  }
                  return SizedBox();
                },
                stream: Database.getReview(widget.username),
              ),
              //---------------------------
              TextField(
                controller: _review,
                decoration: const InputDecoration(
                    labelText: "Masukkan Review", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    //Tambah Review

                    Database.addReview(
                        newReview: Reviews(
                            Review: _review.text, Username: widget.username),
                        c: c);
                    _review.text = "";
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Review berhasil"),
                              content: const Text("Berhasil kirim review!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"))
                              ],
                            ),
                        barrierDismissible: false);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Kirim Review")),
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
