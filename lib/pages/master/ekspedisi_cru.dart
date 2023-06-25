
import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:basicpos_v2/pages/master/ekspedisi.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class ekspedisi_cru extends StatefulWidget {
  final edit;
  final index;
  ekspedisi_cru({super.key, this.edit, this.index});

  static const routeName = '/ekspedisi_cru';

  @override
  State<ekspedisi_cru> createState() => _ekspedisi_cruState();
}

class _ekspedisi_cruState extends State<ekspedisi_cru> {
    CollectionReference _ekspedisi=
      FirebaseFirestore.instance.collection('Ekspedisi');
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController no_telp = TextEditingController();

  var title = "Tambah";
  getId(int index) async {
    QuerySnapshot querySnapshot = await _ekspedisi.get();
    return querySnapshot.docs[index].id;
  }
  getdata() async {
    QuerySnapshot querySnapshot = await _ekspedisi.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      title = "Edit";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "$title Ekspedisi",
          style: TextStyle(
            color: colors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ekspedisi(),
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
                  if (title == "Edit") {
                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data.isEmpty ||
                        snapshot.hasError) {
                      if (snapshot.data == {}) {
                        return Container();
                      } else {
                        if(title == "Edit"){
                        return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        }

                      }
                    } else {
                      if(title == "Edit"){
                      nama.text = snapshot.data[widget.index]["nama"] ?? '-';
                      alamat.text = snapshot.data[widget.index]["alamat"] ?? '-';
                      kota.text = snapshot.data[widget.index]["kota"] ?? '-';
                      no_telp.text = snapshot.data[widget.index]["notelp"] ?? '-';
                      }
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        text_controller: nama,
                        hintText: "Nama",
                        title: "Nama",
                      ),
                      CustomTextField(
                        custom_maxline_size: 3,
                        text_controller: alamat,
                        hintText: "Alamat",
                        title: "Alamat",
                      ),
                      CustomTextField(
                        text_controller: kota,
                        hintText: "Kota",
                        title: "Kota",
                      ),
                      CustomTextField(
                        text_controller: no_telp,
                        hintText: "Nomor Telpon",
                        title: "Nomor Telpon",
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                Map<String, String>? body; 
                body = {
                  "nama": nama.text.toString(),
                  "alamat": alamat.text.toString(),
                  "notelp": no_telp.text.toString(),
                  "kota": kota.text.toString(),
                };
                if (title == "Tambah") {
                  if (nama.text.isEmpty)
                    Fluttertoast.showToast(
                        msg: "Nama barang tidak boleh kosong");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _ekspedisi.add(body);
                  }
                } else {
                  var id = await getId(widget.index);
                  await _ekspedisi.doc(id).update(body);
                  Fluttertoast.showToast(msg: "Success Update");
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
