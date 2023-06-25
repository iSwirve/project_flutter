import 'package:basicpos_v2/pages/stok/memo.dart';
import 'package:basicpos_v2/pages/stok/stok.dart';
import 'package:basicpos_v2/pages/transaksi/laporan%20penjualan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_button.dart';
import '../../constants/dimens.dart' as dimens;
import '../../constants/colors.dart' as colors;

import '../../components/custom_dropdown.dart';
import '../../components/custom_text_field.dart';

class penjualan_cru extends StatefulWidget {
  final edit;
  final index;
  const penjualan_cru({super.key, this.edit, this.index});

  @override
  State<penjualan_cru> createState() => _penjualan_cruState();
}

class _penjualan_cruState extends State<penjualan_cru> {
  var title = 'tambah';
  var idBarang = "";
  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _pelanggan =FirebaseFirestore.instance.collection('Pelanggan');
  CollectionReference _penjualan =FirebaseFirestore.instance.collection('Penjualan');

  SingleValueDropDownController? barang;
  SingleValueDropDownController? pelanggan;

  Map<dynamic, dynamic> barang_data = {};
  Map<dynamic, dynamic> pelanggan_data = {};
  TextEditingController tanggal = TextEditingController();

  getdata() async {
    QuerySnapshot querySnapshot = await _penjualan.get();
    QuerySnapshot querySnapshot1 = await _barang.get();
    QuerySnapshot querySnapshot2 = await _pelanggan.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    var ctr = 0;
    querySnapshot1.docs.forEach(
      (element) {
        barang_data[element.id] =
            querySnapshot1.docs[ctr]["nama_barang"].toString();
        ctr++;
      },
    );

    ctr = 0;
    
    querySnapshot2.docs.forEach(
      (element) {
        pelanggan_data[element.id] =
            querySnapshot2.docs[ctr]["nama_depan"].toString() +
                " " +
                querySnapshot2.docs[ctr]["nama_belakang"].toString();
        ctr++;
      },
    );

    ctr = 0;

    return allData;
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _pelanggan.get();
    return querySnapshot.docs[index].id;
  }

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      title = "Edit";
    }
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Penjualan - $title",
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
                builder: (context) => penjualan(),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: dimens.pagePadding,
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<dynamic>(
                initialData: {},
                future: getdata(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data.isEmpty ||
                      snapshot.hasError) {
                    if (snapshot.data == {}) {
                      return Container();
                    } else {
                      if (title == "Edit") {
                        return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                  } else {
                    if (title == "Edit") {
                      // pelanggan.text =
                      //     snapshot.data[widget.index]["stok_baik"] ?? '-';
                      // tanggal.text =
                      //     snapshot.data[widget.index]["stok_rusak"] ?? '-';
                      // idBarang =
                      //     snapshot.data[widget.index]["id_barang"].toString();
                      // return SingleChildScrollView(
                      //   child: Expanded(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         CustomTextField(
                      //           text_controller: pelanggan,
                      //           hintText: "Stok Baik",
                      //           title: "Stok Baik",
                      //         ),
                      //         CustomTextField(
                      //           text_controller: tanggal,
                      //           hintText: "Stok Rusak",
                      //           title: "Stok Rusak",
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    }
                  }

                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: tanggal,
                            hintText: "Tanggal",
                            title: "Tanggal",
                          ),
                          CustomDropdown(
                            title: "Pelanggan",
                            list: pelanggan_data,
                            controller: barang = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Pelanggan",
                                value: "Pelanggan",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Barang",
                            list: barang_data,
                            controller: barang = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Barang",
                                value: "Barang",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                Map<String, String>? body;

                if (title == "tambah") {
                  body = {
                    'id_barang': barang!.dropDownValue!.value.toString(),
                    'id_pelanggan': pelanggan!.dropDownValue!.value.toString(),
                    'tanggal_penjualan': tanggal.text.toString(),
                  };
                  if (barang!.dropDownValue!.name == "Barang" || pelanggan!.dropDownValue!.name == "Pelanggan")
                    Fluttertoast.showToast(msg: "Silahkan pilih combobox");
                  else if (barang!.dropDownValue!.name == "Barang")
                    Fluttertoast.showToast(msg: "Barang harus dipilih");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _pelanggan.add(body);
                  }
                } else {
                  // body = {
                  //   'id_barang': idBarang,
                  //   'stok_baik': stok_baik.text.toString(),
                  //   'stok_rusak': stok_rusak.text.toString(),
                  // };
                  // var id = await getId(widget.index);
                  // await _pelanggan.doc(id).update(body);
                  // Fluttertoast.showToast(msg: "Sukses update");
                }
              },
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
