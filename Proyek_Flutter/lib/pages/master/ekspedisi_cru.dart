
import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:basicpos_v2/pages/master/ekspedisi.dart';
import 'package:basicpos_v2/pages/master/sales.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class ekspedisi_cru extends StatefulWidget {
  final edit;
  int? index;
  ekspedisi_cru({super.key, this.edit, this.index});

  static const routeName = '/ekspedisi_cru';

  @override
  State<ekspedisi_cru> createState() => _ekspedisi_cruState();
}

class _ekspedisi_cruState extends State<ekspedisi_cru> {
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController no_telp = TextEditingController();

  var title = "Tambah";

  getdata() async {

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
                        return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    } else {
                      nama.text = snapshot.data["name"] ?? '-';
                      alamat.text = snapshot.data["address"] ?? '-';
                      kota.text = snapshot.data["city"] ?? '-';
                      no_telp.text = snapshot.data["phone"] ?? '-';
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
                Map<dynamic, dynamic> body = {
                  "name": nama.text.toString(),
                  "address": alamat.text.toString(),
                  "phone": no_telp.text.toString(),
                  "city": kota.text.toString(),
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
