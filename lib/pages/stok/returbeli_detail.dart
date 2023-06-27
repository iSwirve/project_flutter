import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:basicpos_v2/pages/master/brand_cru.dart';
import 'package:basicpos_v2/pages/stok/returbeli.dart';
import 'package:basicpos_v2/pages/stok/returjual.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/custom_text.dart';

class returbeli_detail extends StatefulWidget {
  final index;

  const returbeli_detail({super.key, this.index});

  @override
  State<returbeli_detail> createState() => _returbeli_detailState();
}

class _returbeli_detailState extends State<returbeli_detail> {
  final CollectionReference _brand = FirebaseFirestore.instance.collection('Brand');

  Future<void> _delete(String productId) async {
    await _brand.doc(productId).delete();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            icon: Container(
              width: 120,
              height: 120,
              child: Image.asset("assets/images/TrashAlert.png"),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Hapus Data',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Apakah anda yakin ingin menghapus data ini?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 108,
                      height: 36,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 239, 248, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(
                            color: Color.fromARGB(255, 24, 72, 169),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Container(
                      width: 108,
                      height: 36,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 24, 72, 169),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Ya',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          var id = await getId(widget.index);
                          _delete(id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => returjual(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Brand');
  Map<dynamic, dynamic> brands = new Map();

  getId(int index) async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    return querySnapshot.docs[index].id;
  }

  CollectionReference _retur = FirebaseFirestore.instance.collection('log_return_seller');
  CollectionReference _supplier = FirebaseFirestore.instance.collection('Supplier');

  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  Map<dynamic, dynamic> BarangData = new Map();
  Map<dynamic, dynamic> SupplierData = new Map();
  getdata() async {
    QuerySnapshot qsRetur = await _retur.get();
    final allData = qsRetur.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Detail Invoice Retur",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => returbeli(),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        left: true,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<dynamic>(
            future: getdata(),
            // You can set initial data or check snapshot.hasData in the builder // Run check for a single queryRow
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                var id_supplier = snapshot.data[widget.index]["id_supplier"].toString();
                var id_barang = snapshot.data[widget.index]["id_barang"].toString();
                var tanggal_terima = snapshot.data[widget.index]["tanggal_terima"].toString();
                var jumlah = snapshot.data[widget.index]["jumlah"].toString();
                var status_ppn = snapshot.data[widget.index]["status_ppn"];
                if (status_ppn == 0)
                  status_ppn = "tidak aktif";
                else
                  status_ppn = "aktif";
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('Supplier').doc('$id_supplier').snapshots(),
                  builder: (context, snaps) {
                    var nama_supplier = snaps.data?['nama_supplier'].toString();
                    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('Barang').doc('$id_barang').snapshots(),
                      builder: (context, snapsh) {
                        var nama_barang = snapsh.data?['nama_barang'].toString();
                        var harga_beli = snapsh.data?['harga_beli'].toString();
                        var subtotal = 0;
                        try {
                          subtotal = int.parse(harga_beli.toString()) * int.parse(jumlah.toString());
                        } catch (Exception) {}

                        return Container(
                          margin: EdgeInsets.only(top: 10, left: 20),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 7),
                                child: Text(
                                  "Data Retur",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 7),
                                child: Column(
                                  children: [
                                    CustomText(
                                      text: "Nama Supplier : $nama_supplier",
                                      //+ brands[widget.index]
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                    CustomText(
                                      text: "Nama Barang : $nama_barang",
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                    CustomText(
                                      text: "Status PPN : $status_ppn",
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                    CustomText(
                                      text: "harga_barang : Rp.$harga_beli",
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                    CustomText(
                                      text: "Jumlah : $jumlah",
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                    CustomText(
                                      text: "Tanggal Terima : $tanggal_terima",
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                    CustomText(
                                      text: "Subtotal : Rp.$subtotal",
                                      textStyle: TextStyle(fontSize: 12),
                                      sizedBox: SizedBox(height: 5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
