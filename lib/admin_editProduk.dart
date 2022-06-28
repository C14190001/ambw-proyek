import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class adminEditProduk extends StatefulWidget {
  const adminEditProduk({Key? key}) : super(key: key);

  @override
  State<adminEditProduk> createState() => _adminEditProdukState();
}

class _adminEditProdukState extends State<adminEditProduk> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Siklus (Admin - Edit Produk)",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Siklus (Admin - Edit Produk)"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
