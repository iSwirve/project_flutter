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

class kategori_barang_cru extends StatefulWidget {
  final edit;
  int? index;
  kategori_barang_cru({super.key, this.edit, this.index});

  static const routeName = '/kategori_barang_cru';

  @override
  State<kategori_barang_cru> createState() => _kategori_barang_cruState();
}

class _kategori_barang_cruState extends State<kategori_barang_cru> {
  TextEditingController nama = TextEditingController();
  SingleValueDropDownController? subkategori;
  Map<dynamic, dynamic> subkategoriData = {};

  var title = "Tambah";

  getdata() async {
    try {

      if (title == "Edit") {

      }
    } catch (e) {
      return [];
    }
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
                      nama.text = snapshot.data["name"] ?? '';
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
                      CustomDropdown(
                        title: "Sub Kategori Dari",
                        list: subkategoriData,
                        controller: subkategori = SingleValueDropDownController(
                          data: DropDownValueModel(
                            name: "Sub Kategori Dari",
                            value: "Sub Kategori Dari",
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                Map<dynamic, dynamic> body;
                try {
                  body = {
                    'parent_id': int.parse(
                      subkategori!.dropDownValue!.value.toString(),
                    ),
                  };
                } catch (e) {
                  print(e.toString());
                }

                body = {
                  'name': nama.text.toString(),
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
