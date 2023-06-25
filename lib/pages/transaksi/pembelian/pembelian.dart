import 'package:basicpos_v2/pages/transaksi/pembelian/pembelian_cru.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';
import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class pembelian extends StatefulWidget {
  const pembelian({super.key});
  static const routeName = '/pembelian';


  @override
  State<pembelian> createState() => _pembelianState();
}

class _pembelianState extends State<pembelian> {
  CollectionReference _collectionPembelian = FirebaseFirestore.instance.collection('Pembelian');
    getdata() async {
    QuerySnapshot querySnapshot = await _collectionPembelian.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Master Pembelian",
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
                builder: (context) => MainMenuPage(),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 44,
                child: Material(
                  elevation: 0.1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: colors.inputBorderPrimary,
                      width: 1,
                    ),
                  ),
                  shadowColor: colors.boxShadow,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Nama Pelanggan',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<dynamic>(
                initialData: [],
                future: getdata(), // Run check for a single queryRow
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data.isEmpty ||
                      snapshot.hasError) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 27),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var idSupplier =
                              snapshot.data[index]["id_supplier"].toString();
                          return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('Supplier')
                                .doc('$idSupplier')
                                .snapshots(),
                            builder: (context, snap) {
                              var data = snap.data?.data();
                              var nama_supplier = data?["nama_supplier"];
                              var ava = nama_supplier
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase();
                              return GestureDetector(
                                onTap: () async {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         stok_detail(index: index),
                                  //   ),
                                  // );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        ava,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      radius: 20,
                                      backgroundColor: colors.primaryLightest,
                                    ),
                                    Container(
                                      height: 56,
                                      color: Colors.white,
                                      child: Text(
                                        nama_supplier.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(top: 18, left: 15),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(bottom: 40, right: 20),
        child: FloatingActionButton(
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pembelian_cru(edit: false),
              ),
            );
          }),
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: colors.secondary,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}