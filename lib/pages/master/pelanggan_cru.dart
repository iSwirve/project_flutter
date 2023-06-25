
import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class pelanggan_cru extends StatefulWidget {
  final edit;
  int? index;
  pelanggan_cru({super.key, this.edit, this.index});

  static const routeName = '/pelanggan';

  @override
  State<pelanggan_cru> createState() => _pelanggan_cruState();
}

class _pelanggan_cruState extends State<pelanggan_cru> {
  TextEditingController nama_depan = TextEditingController();
  TextEditingController nama_belakang = TextEditingController();
  TextEditingController telepon = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController email = TextEditingController();
  Map<dynamic, dynamic> SalesData = {};
  Map<dynamic, dynamic> EkspedisiData = {};
  Map<dynamic, dynamic> KategoriData = {};
  var title = "Tambah";

  getdata() async {

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
          "$title Master pelanggan",
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
                builder: (context) => pelanggan(),
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
                      nama_depan.text = snapshot.data["nama_depan"] ?? '-';
                      nama_belakang.text = snapshot.data["nama_belakang"] ?? '-';
                      alamat.text = snapshot.data["alamat"] ?? '-';
                      telepon.text = snapshot.data["phone"] ?? '-';
                      email.text = snapshot.data["email"] ?? '-';
                    }
                  }
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: nama_depan,
                            hintText: "Nama depan pelanggan",
                            title: "Nama depan pelanggan",
                          ),
                          CustomTextField(
                            text_controller: nama_belakang,
                            hintText: "Nama depan pelanggan",
                            title: "Nama depan pelanggan",
                          ),
                          CustomTextField(
                            text_controller: alamat,
                            hintText: "alamat pelanggan",
                            title: "alamat pelanggan",
                          ),
                          CustomTextField(
                            text_controller: telepon,
                            hintText: "Telpon",
                            title: "Telpon",
                          ),
                          CustomTextField(
                            custom_maxline_size: 3,
                            text_controller: email,
                            hintText: "email pelanggan",
                            title: "email pelanggan",
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
                Map<String, String> body;
                int count = await FirebaseFirestore.instance.collection('Pelanggan').get().then((value) => value.size);
                body = {  
                  'alamat': alamat.text.toString(),
                  'email': email.text.toString(),
                  'id': count.toString(),
                  'nama_belakang': nama_belakang.text.toString(),
                  "nama_depan": nama_depan.text.toString(),
                  'telepon': telepon.text.toString(),
                };

                if (title == "Tambah") {
                  FirebaseFirestore.instance.collection("Pelanggan").add(body);
                  Fluttertoast.showToast(msg: "Sukses insert");
                } else {

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

