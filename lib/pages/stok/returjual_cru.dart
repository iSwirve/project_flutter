import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/pages/stok/returjual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class returjual_cru extends StatefulWidget {
  final edit;
  final index;

  returjual_cru({super.key, this.edit, this.index});

  static const routeName = '/barang';

  @override
  State<returjual_cru> createState() => _retur_cruState();
}

class _retur_cruState extends State<returjual_cru> {
  var title = "Tambah";

  SingleValueDropDownController? barang_controller;
  SingleValueDropDownController? pelanggan_controller;
  TextEditingController jumlahRetur = TextEditingController();
  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _pelanggan =
      FirebaseFirestore.instance.collection('Pelanggan');
  CollectionReference retur =
  FirebaseFirestore.instance.collection('log_return_buyer');
  Map<dynamic, dynamic> BarangData = new Map();
  Map<dynamic, dynamic> PelangganData = new Map();

  getdata() async {
    QuerySnapshot qsBarang = await _barang.get();
    final dataBarang = qsBarang.docs.map((doc) => doc.data()).toList();

    var ctr = 0;

    qsBarang.docs.forEach((element) {
      BarangData[element.reference.id] = element["nama_barang"];
      ctr++;
    });

    QuerySnapshot qsPelanggan = await _pelanggan.get();
    final dataPelanggan = qsBarang.docs.map((doc) => doc.data()).toList();

    ctr = 0;

    qsPelanggan.docs.forEach((element) {
      PelangganData[element.reference.id] = element["nama_depan"] + " " + element["nama_belakang"];
      ctr++;
    });

    return [dataBarang];
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
          "Tambah Retur Jual",
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
                builder: (context) => returjual(),
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
                  } else {}
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropdown(
                            title: "Barang yang di retur",
                            list: BarangData,
                            controller: barang_controller =
                                SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Barang",
                                value: "Barang",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Nama Pelanggan",
                            list: PelangganData,
                            controller: pelanggan_controller =
                                SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Nama Pelanggan",
                                value: "Nama",
                              ),
                            ),
                          ),
                          CustomTextField(
                            text_controller: jumlahRetur,
                            hintText: "Stok Retur",
                            title: "Stok Minimum",
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
                body = {
                  'id_barang': barang_controller!.dropDownValue!.value.toString(),
                  'pelanggan': pelanggan_controller!.dropDownValue!.value.toString(),
                  'jumlah': jumlahRetur.text.toString(),

                };

                // if (title == "Tambah") {
                  if (jumlahRetur.text.isEmpty)
                    Fluttertoast.showToast(
                        msg: "Nama barang tidak boleh kosong");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await retur.add(body);
                  }
                // } else {
                //   var id = await getId(widget.index);
                //   await _collectionRef3.doc(id).update(body);
                //   Fluttertoast.showToast(msg: "Sukses update");
                // }
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
