import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class brand_cru extends StatefulWidget {
  final edit;
  int? index;

  brand_cru({super.key, this.edit, this.index});

  static const routeName = '/brand_cru';

  @override
  State<brand_cru> createState() => _brand_cruState();
}

class _brand_cruState extends State<brand_cru> {
  TextEditingController nama = TextEditingController();

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
          "$title Brand",
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
                builder: (context) => brand(),
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
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        text_controller: nama,
                        hintText: "Nama Brand",
                        title: "Nama Brand",
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
                  "name": nama.text.toString(),
                };

                if (title == "Tambah") {
                  if (nama.text.toString().isNotEmpty) {
                    FirebaseFirestore.instance.collection('Brand').add(body);
                    Fluttertoast.showToast(msg: "Success Tambah");
                  } else {
                    Fluttertoast.showToast(msg: "Field tidak boleh kosong");
                  }
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
