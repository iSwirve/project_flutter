import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/constants/colors.dart';
import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:basicpos_v2/pages/master/kategori_pelanggan.dart';
import 'package:basicpos_v2/pages/master/sales.dart';
import 'package:basicpos_v2/pages/master/supplier.dart';
import 'package:basicpos_v2/pages/master/supplier_detail.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpers/helpers/widgets/widgets.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class sales_cru extends StatefulWidget {
  final edit;
  int? index;
  sales_cru({super.key, this.edit, this.index});

  static const routeName = '/sales_cru';

  @override
  State<sales_cru> createState() => _sales_cruState();
}

class _sales_cruState extends State<sales_cru> {
  TextEditingController nama = TextEditingController();

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
          "$title Sales",
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
                builder: (context) => sales(),
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
                Map<String, String> body = {
                  "name": nama.text.toString(),
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
