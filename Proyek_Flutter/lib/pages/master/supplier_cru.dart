import 'package:basicpos_v2/pages/master/supplier.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class supplier_cru extends StatefulWidget {
  final edit;
  int? index;
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

  getdata() async {}

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
                      nama.text = snapshot.data["nama"] ?? '';
                      kode.text = snapshot.data["kode"] ?? '';
                      telpon.text = snapshot.data["telpon"] ?? '';
                      alamat.text = snapshot.data["alamat"] ?? '';
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
                  "code": kode.text.toString(),
                  "name": nama.text.toString(),
                  "address": alamat.text.toString(),
                  "phone": telpon.text.toString(),
                };
                if (title == "Tambah") {
                  Fluttertoast.showToast(msg: "Success Insert");
                } else {
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
