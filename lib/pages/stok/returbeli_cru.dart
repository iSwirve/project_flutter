import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/pages/stok/returbeli.dart';
import 'package:basicpos_v2/pages/stok/returjual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class returbeli_cru extends StatefulWidget {
  final edit;
  final index;

  returbeli_cru({super.key, this.edit, this.index});

  static const routeName = '/barang';

  @override
  State<returbeli_cru> createState() => _retur_cruState();
}

class _retur_cruState extends State<returbeli_cru> {
  var title = "Tambah";

  SingleValueDropDownController? barang_controller;
  SingleValueDropDownController? Supplier_controller;
  SingleValueDropDownController? status_ppn_controller;
  TextEditingController tanggal_terima= TextEditingController();
  TextEditingController jumlahRetur = TextEditingController();
  TextEditingController status_ppn = TextEditingController();
  TextEditingController harga_barang_text = TextEditingController();
  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _supplier = FirebaseFirestore.instance.collection('Supplier');
  CollectionReference retur = FirebaseFirestore.instance.collection('log_return_seller');
  Map<dynamic, dynamic> statusppn_data = {"0": "Tidak Aktif", "1": "Aktif"};
  Map<dynamic, dynamic> BarangData = new Map();
  Map<dynamic, dynamic> SupplierData = new Map();
  Map<dynamic, dynamic> harga_barang = new Map();
  getdata() async {
    QuerySnapshot qsBarang = await _barang.get();
    final dataBarang = qsBarang.docs.map((doc) => doc.data()).toList();

    var ctr = 0;

    qsBarang.docs.forEach((element) {
      BarangData[element.reference.id] = element["nama_barang"];
      harga_barang[element.reference.id] = element["harga_beli"];
      ctr++;
    });

    QuerySnapshot qsSupplier = await _supplier.get();
    final dataSupplier = qsBarang.docs.map((doc) => doc.data()).toList();

    ctr = 0;

    qsSupplier.docs.forEach((element) {
      SupplierData[element.reference.id] = element["nama_supplier"];
      ctr++;
    });

    return [dataBarang];
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
          "Tambah Retur Beli",
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
                builder: (context) => returbeli(),
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
                  if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty || snapshot.hasError) {
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
                  } else {}

                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropdown(
                            title: "Barang yang di retur",
                            list: BarangData,
                            controller: barang_controller = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Barang",
                                value: "Barang",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Nama Supplier",
                            list: SupplierData,
                            controller: Supplier_controller = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Nama Supplier",
                                value: "Nama",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Status PPN",
                            list: statusppn_data,
                            controller: status_ppn_controller = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Status_PPN",
                                value: "Status_PPN",
                              ),
                            ),
                          ),
                          CustomTextField(
                            text_controller: harga_barang_text,
                            hintText: "Harga Barang",
                            title: "Harga Barang",
                          ),
                          CustomTextField(
                            text_controller: jumlahRetur,
                            hintText: "Stok Retur",
                            title: "Stok Barang",
                          ),
                          CustomTextField(
                            text_controller: tanggal_terima,
                            hintText: "tanggal terima",
                            title: "tanggal terima",
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
                  'harga_barang': harga_barang_text.text.toString(),
                  'id_barang': barang_controller!.dropDownValue!.value.toString(),
                  'id_supplier': Supplier_controller!.dropDownValue!.value.toString(),
                  'jumlah': jumlahRetur.text.toString(),
                  'status_ppn': status_ppn_controller!.dropDownValue!.value.toString(),
                  'tanggal_terima': tanggal_terima.text.toString(),
                };

                // if (title == "Tambah") {
                if (jumlahRetur.text.isEmpty)
                  Fluttertoast.showToast(msg: "Nama barang tidak boleh kosong");
                else {
                  Fluttertoast.showToast(msg: "Sukses Insert");
                  await retur.add(body);
                }
                // } else {
                //   var id = await getId(widget.index);
                //   await _collectionRef3.doc(id).update(body);
                //   Fluttertoast.showToast(msg: "Sukses update");
                // }
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
