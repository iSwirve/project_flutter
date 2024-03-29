import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/kategori_barang.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class kategori_barang_cru extends StatefulWidget {
  final edit;
  final index;

  kategori_barang_cru({super.key, this.edit, this.index});

  static const routeName = '/kategori_barang_cru';

  @override
  State<kategori_barang_cru> createState() => _kategori_barang_cruState();
}

class _kategori_barang_cruState extends State<kategori_barang_cru> {
  TextEditingController nama = TextEditingController();
  SingleValueDropDownController? subkategori;

  var title = "Tambah";

  CollectionReference _collectionRef3 = FirebaseFirestore.instance.collection('Kategori');
  getdata() async {
    QuerySnapshot querySnapshot = await _collectionRef3.get();
    final dataBrand = querySnapshot.docs.map((doc) => doc.data()).toList();
    return dataBrand;
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _collectionRef3.get();
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
          "$title Kategori Barang",
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
                builder: (context) => kategori_barang(),
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
                    if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty || snapshot.hasError) {
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
                      nama.text = snapshot.data[widget.index]["name"] ?? '';
                      ;
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        text_controller: nama,
                        hintText: "Nama Kategori",
                        title: "Nama Kategori",
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                Map<String, String> body;
                // try {
                //   body = {
                //     'parent_id': int.parse(
                //       subkategori!.dropDownValue!.value.toString(),
                //     ),
                //   };
                // } catch (e) {
                //   print(e.toString());
                // }

                body = {
                  "name": nama.text.toString(),
                };
                if (title == "Tambah") {
                  if (nama.text.toString().isNotEmpty) {
                    FirebaseFirestore.instance.collection('Kategori').add(body);
                  } else {
                    Fluttertoast.showToast(msg: "Field tidak boleh kosong");
                  }

                  Fluttertoast.showToast(msg: "Success Insert");
                } else {
                  if (nama.text.toString().isNotEmpty) {
                    var id = await getId(widget.index);
                    await _collectionRef3.doc(id).update(body);
                    Fluttertoast.showToast(msg: "Success Update");
                  } else {
                    Fluttertoast.showToast(msg: "Field tidak boleh kosong");
                  }
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
