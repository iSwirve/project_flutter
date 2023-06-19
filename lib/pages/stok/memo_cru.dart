import 'package:basicpos_v2/pages/stok/memo.dart';
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

class memo_cru extends StatefulWidget {
  final edit;
  final index;
  const memo_cru({super.key,this.edit,this.index});

  @override
  State<memo_cru> createState() => _memo_cruState();
}

class _memo_cruState extends State<memo_cru> {
  var title = 'tambah';
  CollectionReference _collectionRef1 =
      FirebaseFirestore.instance.collection('Memo');
  CollectionReference _collectionRef2 =
      FirebaseFirestore.instance.collection('Barang');    
  SingleValueDropDownController? barang;
  Map<dynamic, dynamic> barang_data = {};
  TextEditingController catatan = TextEditingController();
  TextEditingController judul_memo = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController tanggal = TextEditingController();
  TextEditingController id_barang = TextEditingController();

    getdata() async {
    QuerySnapshot querySnapshot = await _collectionRef1.get();
    QuerySnapshot querySnapshot2 = await _collectionRef2.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var ctr = 0;
    querySnapshot2.docs.forEach((element) {
      barang_data[element.id] = querySnapshot2.docs[ctr]["nama_barang"].toString();
      ctr++;
      });

    ctr = 0;
    return allData;
  }
  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      title = "Edit";
    }
    getdata();
  }
  getId(int index) async {
    QuerySnapshot querySnapshot = await _collectionRef1.get();
    return querySnapshot.docs[index].id;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Memo - $title",
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
                builder: (context) => memo(),
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
                      judul_memo.text =
                          snapshot.data[widget.index]["judul_memo"] ?? '-';
                      qty.text =
                          snapshot.data[widget.index]["qty"] ?? '-';
                      tanggal.text =
                          snapshot.data[widget.index]["tanggal"] ?? '-';
                      id_barang.text =
                          (snapshot.data[widget.index]["id_barang"] ?? 0)
                              .toString();
                      catatan.text =
                          (snapshot.data[widget.index]["catatan"] ?? 0)
                              .toString();
                    }
                  }
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: judul_memo,
                            hintText: "Judul Memo",
                            title: "judul memo",
                          ),
                          CustomTextField(
                            text_controller: catatan,
                            hintText: "Catatan",
                            title: "Catatan",
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
                          CustomTextField(
                            text_controller: qty,
                            hintText: "QTY",
                            title: "QTY",
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
                  'catatan': catatan.text.toString(),
                  'id_barang':
                      barang!.dropDownValue!.value.toString(),
                  'judul_memo': judul_memo.text.toString(),
                  'qty': qty.text.toString(),
                };

                if (title == "tambah") {
                  if (judul_memo.text.isEmpty)
                    Fluttertoast.showToast(
                        msg: "Memo tidak boleh kosong");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _collectionRef1.add(body);
                  }
                } else {
                  // var id = await getId(widget.index);
                  // await _collectionRef1.doc(id).update(body);
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