import 'package:basicpos_v2/pages/transaksi/pembelian/pembelian.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/custom_button.dart';
import '../../../constants/dimens.dart' as dimens;
import '../../../constants/colors.dart' as colors;

import '../../../components/custom_dropdown.dart';
import '../../../components/custom_text_field.dart';

class pembelian_cru extends StatefulWidget {
  final edit;
  final index;
  const pembelian_cru({super.key, this.edit, this.index});

  @override
  State<pembelian_cru> createState() => _pembelian_cruState();
}

class _pembelian_cruState extends State<pembelian_cru> {
  var title = 'tambah';
  var idBarang = "";
  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _supplier = FirebaseFirestore.instance.collection('Supplier');
  CollectionReference _pembelian = FirebaseFirestore.instance.collection('Pembelian');

  SingleValueDropDownController? barang;
  SingleValueDropDownController? supplier;
  SingleValueDropDownController? statusppn;
  TextEditingController tanggal = TextEditingController();
  TextEditingController tanggal_tempo = TextEditingController();
  TextEditingController tanggal_terima = TextEditingController();

  Map<dynamic, dynamic> barang_data = {};
  Map<dynamic, dynamic> supplier_data = {};
  Map<dynamic, dynamic> statusppn_data = {"0": "Tidak Aktif", "1": "Aktif"};

  getdata() async {
    QuerySnapshot querySnapshot = await _pembelian.get();
    QuerySnapshot querySnapshot1 = await _barang.get();
    QuerySnapshot querySnapshot2 = await _supplier.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    var ctr = 0;
    querySnapshot1.docs.forEach(
      (element) {
        barang_data[element.id] = querySnapshot1.docs[ctr]["nama_barang"].toString();
        ctr++;
      },
    );

    ctr = 0;

    querySnapshot2.docs.forEach(
      (element) {
        supplier_data[element.id] = querySnapshot2.docs[ctr]["nama_supplier"].toString();
        ctr++;
      },
    );

    ctr = 0;

    return allData;
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _pembelian.get();
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
          "Pembelian - $title",
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
                builder: (context) => pembelian(),
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
                  } else {
                    if (title == "Edit") {
                      // 'id_barang': barang!.dropDownValue!.value.toString(),
                      // 'id_supplier': supplier!.dropDownValue!.value.toString(),
                      // 'tanggal': tanggal.text.toString(),
                      // 'tanggal_tempo' : tanggal_tempo.text.toString(),
                      // 'tanggal_terima' : tanggal_terima.text.toString(),
                      // 'status_ppn' : statusppn!.dropDownValue!.value.toString()
                      tanggal.text = snapshot.data[widget.index]["tanggal"] ?? '-';
                      tanggal_tempo.text = snapshot.data[widget.index]["tanggal_tempo"] ?? '-';
                      tanggal_terima.text = snapshot.data[widget.index]["tanggal_terima"] ?? '-';

                      // pelanggan.text =
                      //     snapshot.data[widget.index]["stok_baik"] ?? '-';
                      // tanggal.text =
                      //     snapshot.data[widget.index]["stok_rusak"] ?? '-';
                      // idBarang =
                      //     snapshot.data[widget.index]["id_barang"].toString();

                      return SingleChildScrollView(
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                text_controller: tanggal,
                                hintText: "Tanggal",
                                title: "Tanggal",
                              ),
                              CustomTextField(
                                text_controller: tanggal_tempo,
                                hintText: "Tanggal Jatuh Tempo",
                                title: "Tanggal Jatuh Tempo",
                              ),
                              CustomTextField(
                                text_controller: tanggal_terima,
                                hintText: "Tanggal Terima",
                                title: "Tanggal Terima",
                              ),
                              CustomDropdown(
                                title: "Supplier",
                                list: supplier_data,
                                controller: supplier = SingleValueDropDownController(
                                  data: DropDownValueModel(
                                    name: "Supplier",
                                    value: "Supplier",
                                  ),
                                ),
                              ),
                              CustomDropdown(
                                title: "Barang",
                                list: barang_data,
                                controller: barang = SingleValueDropDownController(
                                  data: DropDownValueModel(
                                    name: "Barang",
                                    value: "Barang",
                                  ),
                                ),
                              ),
                              CustomDropdown(
                                title: "Status PPN",
                                list: statusppn_data,
                                controller: statusppn = SingleValueDropDownController(
                                    data: DropDownValueModel(name: "Status PPN", value: "Status PPN")),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: tanggal,
                            hintText: "Tanggal",
                            title: "Tanggal",
                          ),
                          CustomTextField(
                            text_controller: tanggal_tempo,
                            hintText: "Tanggal Jatuh Tempo",
                            title: "Tanggal Jatuh Tempo",
                          ),
                          CustomTextField(
                            text_controller: tanggal_terima,
                            hintText: "Tanggal Terima",
                            title: "Tanggal Terima",
                          ),
                          CustomDropdown(
                            title: "Supplier",
                            list: supplier_data,
                            controller: supplier = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Supplier",
                                value: "Supplier",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Barang",
                            list: barang_data,
                            controller: barang = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Barang",
                                value: "Barang",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Status PPN",
                            list: statusppn_data,
                            controller: statusppn = SingleValueDropDownController(
                                data: DropDownValueModel(name: "Status PPN", value: "Status PPN")),
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

                if (title == "tambah") {
                  body = {
                    'id_barang': barang!.dropDownValue!.value.toString(),
                    'id_supplier': supplier!.dropDownValue!.value.toString(),
                    'tanggal': tanggal.text.toString(),
                    'tanggal_tempo': tanggal_tempo.text.toString(),
                    'tanggal_terima': tanggal_terima.text.toString(),
                    'status_ppn': statusppn!.dropDownValue!.value.toString()
                  };
                  if (barang!.dropDownValue!.name == "Barang" || supplier!.dropDownValue!.name == "Supplier")
                    Fluttertoast.showToast(msg: "Silahkan pilih combobox");
                  else if (barang!.dropDownValue!.name == "Barang")
                    Fluttertoast.showToast(msg: "Barang harus dipilih");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _pembelian.add(body);
                  }
                } else {
                  var id = await getId(widget.index);
                  body = {
                    'id_barang': barang!.dropDownValue!.value.toString(),
                    'id_supplier': supplier!.dropDownValue!.value.toString(),
                    'tanggal': tanggal.text.toString(),
                    'tanggal_tempo': tanggal_tempo.text.toString(),
                    'tanggal_terima': tanggal_terima.text.toString(),
                    'status_ppn': statusppn!.dropDownValue!.value.toString()
                  };
                  if (barang!.dropDownValue!.name == "Barang" || supplier!.dropDownValue!.name == "Supplier")
                    Fluttertoast.showToast(msg: "Silahkan pilih combobox");
                  else if (barang!.dropDownValue!.name == "Barang")
                    Fluttertoast.showToast(msg: "Barang harus dipilih");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Update !!");
                    await _pembelian.doc(id).update(body);
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
