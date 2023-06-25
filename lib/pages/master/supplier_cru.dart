import 'package:basicpos_v2/pages/master/supplier.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class supplier_cru extends StatefulWidget {
  final edit;
  final index;
  supplier_cru({super.key, this.edit, this.index});

  static const routeName = '/suppliers';

  @override
  State<supplier_cru> createState() => _supplier_cruState();
}

class _supplier_cruState extends State<supplier_cru> {
  TextEditingController nama = TextEditingController();
  TextEditingController kode = TextEditingController();
  TextEditingController telpon = TextEditingController();
  TextEditingController alamat = TextEditingController();
  var title = "Tambah";

  CollectionReference _supplier =
      FirebaseFirestore.instance.collection('Supplier');
  getdata() async {
    QuerySnapshot querySnapshot = await _supplier.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _supplier.get();
    return querySnapshot.docs[index].id;
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
          "$title Master Supplier",
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
                builder: (context) => supplier(),
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
                        return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    } else {
                      nama.text =
                          snapshot.data[widget.index]["nama_supplier"] ?? '';
                      kode.text = snapshot.data[widget.index]["kode"] ?? '';
                      telpon.text = snapshot.data[widget.index]["telpon"] ?? '';
                      alamat.text = snapshot.data[widget.index]["alamat"] ?? '';
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        text_controller: nama,
                        hintText: "Nama Supplier",
                        title: "Nama Supplier",
                      ),
                      CustomTextField(
                        text_controller: kode,
                        hintText: "Kode",
                        title: "Kode",
                      ),
                      CustomTextField(
                        text_controller: telpon,
                        hintText: "Telpon",
                        title: "Telpon",
                      ),
                      CustomTextField(
                        text_controller: alamat,
                        hintText: "Alamat",
                        title: "Alamat",
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                Map<String, String> body = {
                  "kode": kode.text.toString(),
                  "nama_supplier": nama.text.toString(),
                  "alamat": alamat.text.toString(),
                  "telpon": telpon.text.toString(),
                };
                if (title == "Tambah") {
                  //function
                  FirebaseFirestore.instance.collection('Supplier').add(body);
                  Fluttertoast.showToast(msg: "Success Insert");
                } else {
                  var id = await getId(widget.index);
                  await _supplier.doc(id).update(body);
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
