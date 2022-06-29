import 'package:ambw_proyek/admin_main.dart';
import 'package:ambw_proyek/database_api.dart';
import 'package:ambw_proyek/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class adminEditProduk extends StatefulWidget {
  final Product? editP;
  final String username;
  const adminEditProduk({Key? key, required this.username, this.editP})
      : super(key: key);

  @override
  State<adminEditProduk> createState() => _adminEditProdukState();
}

class _adminEditProdukState extends State<adminEditProduk> {
  bool _addProduct = false;
  String _title = "Edit Produk";
  final TextEditingController _Descriptions = TextEditingController();
  final TextEditingController _Name = TextEditingController();
  final TextEditingController _PictureURL = TextEditingController();
  final TextEditingController _Price = TextEditingController();
  final TextEditingController _Stock = TextEditingController();

  @override
  void initState() {
    _Name.text = widget.editP?.Name ?? "";
    _Descriptions.text = widget.editP?.Descriptions ?? "";
    //_PictureURL.text = widget.editP?.PictureURL ?? "";

    _PictureURL.text = widget.editP?.PictureURL ??
        "https://12college.files.wordpress.com/2016/05/test-clip-art-cpa-school-test.png";

    _Price.text = widget.editP?.Price ?? "";
    _Stock.text = widget.editP?.Stock ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editP == null) {
      _addProduct = true;
      _title = "Tambah Produk";
    }
    return MaterialApp(
      title: "Siklus (Admin - Edit Produk)",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Siklus (Admin - $_title)"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nama produk:"),
                      TextField(
                        controller: _Name,
                        enabled: _addProduct,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Deskripsi produk:"),
                      TextField(
                        controller: _Descriptions,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Gambar produk (URL):"),
                      TextField(
                        controller: _PictureURL,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Harga produk:"),
                      Row(
                        children: [
                          const Text("Rp. ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: TextField(
                              controller: _Price,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Stok produk:"),
                      TextField(
                        controller: _Stock,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ]),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_Name.text.isNotEmpty &&
                        _Descriptions.text.isNotEmpty &&
                        _PictureURL.text.isNotEmpty &&
                        _Price.text.isNotEmpty &&
                        _Stock.text.isNotEmpty) {
                      if (_addProduct) {
                        Database.addProduct(
                            newProduct: Product(
                                Descriptions: _Descriptions.text,
                                Name: _Name.text,
                                PictureURL: _PictureURL.text,
                                Price: _Price.text,
                                Stock: _Stock.text));
                      } else {
                        Database.editProduct(
                            editedProduct: Product(
                                Descriptions: _Descriptions.text,
                                Name: _Name.text,
                                PictureURL: _PictureURL.text,
                                Price: _Price.text,
                                Stock: _Stock.text));
                      }
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("$_title berhasil!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK")),
                                ],
                              ),
                          barrierDismissible: false);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("$_title gagal!"),
                                content: const Text("Data belum lengkap"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK")),
                                ],
                              ),
                          barrierDismissible: false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: Text(_title)),
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
