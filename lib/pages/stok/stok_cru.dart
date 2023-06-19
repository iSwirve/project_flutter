import 'package:basicpos_v2/pages/stok/memo.dart';
import 'package:basicpos_v2/pages/stok/stok.dart';
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

class stok_cru extends StatefulWidget {
  final edit;
  final index;
  const stok_cru({super.key, this.edit, this.index});

  @override
  State<stok_cru> createState() => _stok_cruState();
}

class _stok_cruState extends State<stok_cru> {
  var title = 'tambah';
  var idBarang = "";
  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _stok = FirebaseFirestore.instance.collection('Stok');
  SingleValueDropDownController? barang;
  Map<dynamic, dynamic> barang_data = {};
  TextEditingController stok_baik = TextEditingController();
  TextEditingController stok_rusak = TextEditingController();

  getdata() async {
    QuerySnapshot querySnapshot = await _stok.get();
    QuerySnapshot querySnapshot1 = await _barang.get();
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
    return allData;
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _stok.get();
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
          "Stok - $title",
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
                builder: (context) => stok(),
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
                      stok_baik.text =
                          snapshot.data[widget.index]["stok_baik"] ?? '-';
                      stok_rusak.text =
                          snapshot.data[widget.index]["stok_rusak"] ?? '-';
                      idBarang =
                          snapshot.data[widget.index]["id_barang"].toString();
                      return SingleChildScrollView(
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                text_controller: stok_baik,
                                hintText: "Stok Baik",
                                title: "Stok Baik",
                              ),
                              CustomTextField(
                                text_controller: stok_rusak,
                                hintText: "Stok Rusak",
                                title: "Stok Rusak",
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: stok_baik,
                            hintText: "Stok Baik",
                            title: "Stok Baik",
                          ),
                          CustomTextField(
                            text_controller: stok_rusak,
                            hintText: "Stok Rusak",
                            title: "Stok Rusak",
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
                    'stok_baik': stok_baik.text.toString(),
                    'stok_rusak': stok_rusak.text.toString(),
                  };
                  if (stok_baik.text.isEmpty || stok_rusak.text.isEmpty)
                    Fluttertoast.showToast(msg: "Field tidak boleh kosong");
                  else if (barang!.dropDownValue!.name == "Barang")
                    Fluttertoast.showToast(msg: "Barang harus dipilih");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _stok.add(body);
                  }
                } else {
                  body = {
                    'id_barang': idBarang,
                    'stok_baik': stok_baik.text.toString(),
                    'stok_rusak': stok_rusak.text.toString(),
                  };
                  var id = await getId(widget.index);
                  await _stok.doc(id).update(body);
                  Fluttertoast.showToast(msg: "Sukses update");
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
