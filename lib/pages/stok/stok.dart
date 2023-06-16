import 'dart:convert';

import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:basicpos_v2/pages/master/supplier_cru.dart';
import 'package:basicpos_v2/pages/master/supplier_detail.dart';
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class stok extends StatefulWidget {
  const stok({super.key});
  static const routeName = '/stok';

  @override
  State<stok> createState() => _stokState();
}

class _stokState extends State<stok> {
  getdata() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('Stok');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  // getBarangData(String id) async {
  //   var data = [];
  //   var document = await FirebaseFirestore.instance.collection('Barang').doc(id).get();

  //   document.get().then(function(document) {
  //     print(document("name"));
  //   });
  //   return document.data();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Master Stok",
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
                      hintText: 'Nama Barang',
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
                          var idBarang =
                              snapshot.data[index]["id_barang"].toString();
                          var stok_baik = int.parse(
                              snapshot.data[index]["stok_baik"].toString());
                          var stok_rusak = int.parse(
                              snapshot.data[index]["stok_rusak"].toString());
                          // var ava =
                          //     name.toString().substring(0, 1).toUpperCase();
                          return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('Barang')
                                .doc(idBarang)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  child: Text("No Data"),
                                );
                              } else {
                                var data = snapshot.data!.data();
                                return Container(
                                  child: Text(
                                    data!["kode_barang"],
                                  ),
                                );
                              }
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
                builder: (context) => supplier_cru(edit: false),
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
