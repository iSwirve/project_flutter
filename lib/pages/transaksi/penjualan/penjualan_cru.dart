import 'package:basicpos_v2/pages/transaksi/penjualan/penjualan.dart';
import 'package:basicpos_v2/pages/transaksi/penjualan/penjualan_cru.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpers/helpers/extensions/extensions.dart';
import '../../../components/custom_small_button.dart';
import '../../../constants/dimens.dart' as dimens;
import '../../../constants/colors.dart' as colors;

import '../../../components/custom_dropdown.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_field.dart';

class penjualan_cru extends StatefulWidget {
  final edit;
  final index;
  const penjualan_cru({super.key, this.edit, this.index});

  @override
  State<penjualan_cru> createState() => _penjualan_cruState();
}

class _penjualan_cruState extends State<penjualan_cru> {
  var title = 'tambah';
  var idBarang = "";
  CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _pelanggan = FirebaseFirestore.instance.collection('Pelanggan');
  CollectionReference _penjualan = FirebaseFirestore.instance.collection('Penjualan');

  SingleValueDropDownController? pelanggan, statusppn;

  Map<dynamic, dynamic> pelanggan_data = {};
  Map<dynamic, dynamic> statusppn_data = {"0": "Tidak Aktif", "1": "Aktif"};
  TextEditingController tanggal = TextEditingController();
  TextEditingController tanggal_tempo = TextEditingController();
  List<bool>? _selected;
  List<int>? _numbarang;
  List<Map>? _selectedBarang;

  getdata() async {
    QuerySnapshot querySnapshot = await _penjualan.get();
    QuerySnapshot querySnapshot2 = await _pelanggan.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    var ctr = 0;
    querySnapshot2.docs.forEach(
      (element) {
        pelanggan_data[element.id] = querySnapshot2.docs[ctr]["nama_depan"].toString() +
            " " +
            querySnapshot2.docs[ctr]["nama_belakang"].toString();
        ctr++;
      },
    );

    ctr = 0;

    return allData;
  }

  getBarang() async {
    QuerySnapshot querySnapshot1 = await _barang.get();
    final allData = querySnapshot1.docs.map((doc) => doc.data()).toList();
    if (_selected == null) _selected = List.generate(allData.length, (i) => false);
    if (_numbarang == null) _numbarang = List.generate(allData.length, (i) => 0);
    if (_selectedBarang == null)
      _selectedBarang = List.generate(allData.length, (i) => {"nama_barang": "", "qty": "", "harga_jual": ""});
    return allData;
  }

  getIdPelanggan(int index) async {
    QuerySnapshot querySnapshot = await _pelanggan.get();
    return querySnapshot.docs[index].id;
  }

  getIdPenjualan(int index) async {
    QuerySnapshot querySnapshot = await _penjualan.get();
    return querySnapshot.docs[index].id;
  }

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      title = "Edit";
    }
    getdata();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Penjualan - $title",
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
                builder: (context) => penjualan(),
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
                      tanggal.text = snapshot.data[widget.index]["tanggal_penjualan"] ?? '-';
                      tanggal_tempo.text = snapshot.data[widget.index]["tanggal_tempo"] ?? '-';
                    }
                  }

                  return Column(
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
                      CustomDropdown(
                        title: "Pelanggan",
                        list: pelanggan_data,
                        controller: pelanggan = SingleValueDropDownController(
                          data: DropDownValueModel(
                            name: "Pelanggan",
                            value: "Pelanggan",
                          ),
                        ),
                      ),
                      CustomDropdown(
                        title: "Status PPN",
                        list: statusppn_data,
                        controller: statusppn = SingleValueDropDownController(
                          data: DropDownValueModel(
                            name: "Status PPN",
                            value: "Status PPN",
                          ),
                        ),
                      ),
                      CustomButtonSmall(
                        text: "Cari Barang",
                        onPressed: () {
                          showModalBottomSheet<void>(
                            backgroundColor: Colors.transparent,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.98,
                            ),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter modalsheetSetter) {
                                  return Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height * 0.60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 4,
                                          margin: EdgeInsets.only(top: 20),
                                          child: TextButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(255, 122, 126, 128),
                                            ),
                                            child: const Text(''),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          child: ListTile(
                                            leading: Text(
                                              "List Barang",
                                              textScaleFactor: 1.2,
                                            ),
                                            trailing: Container(
                                              width: 70,
                                              child: Text(
                                                "Qty",
                                                textScaleFactor: 1.2,
                                              ),
                                            ),
                                            title: Text(""),
                                          ),
                                        ),
                                        FutureBuilder<dynamic>(
                                          initialData: {},
                                          future: getBarang(),
                                          builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                            return Container(
                                              height: MediaQuery.of(context).size.height * 0.4,
                                              child: ListView.builder(
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (_, int index) {
                                                  return ListTile(
                                                    trailing: Container(
                                                      width: 108,
                                                      child: _selected![index]
                                                          ? new Row(
                                                              children: [
                                                                Container(
                                                                  width: 48,
                                                                ),
                                                                new Text(_numbarang![index].toString()),
                                                              ],
                                                            )
                                                          : new Row(
                                                              children: [
                                                                _numbarang![index] != 0
                                                                    ? new IconButton(
                                                                        icon: new Icon(Icons.remove),
                                                                        onPressed: () => modalsheetSetter(
                                                                          () => _numbarang![index]--,
                                                                        ),
                                                                      )
                                                                    : new Container(
                                                                        width: 50,
                                                                      ),
                                                                new Text(_numbarang![index].toString()),
                                                                new IconButton(
                                                                  icon: new Icon(Icons.add),
                                                                  onPressed: () => modalsheetSetter(
                                                                    () => _numbarang![index]++,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                    ),
                                                    leading: _selected![index] ? Icon(Icons.done) : Icon(Icons.add),
                                                    title: Text(
                                                      snapshot.data[index]["nama_barang"],
                                                    ),
                                                    subtitle: Text('Tap to add barang'),
                                                    selected: _selected![index],
                                                    onTap: () {
                                                      modalsheetSetter(() {
                                                        _selected![index] = !_selected![index];
                                                      });
                                                      if (_selected![index]) {
                                                        _selectedBarang![index] = {
                                                          "nama_barang": snapshot.data[index]["nama_barang"].toString(),
                                                          "harga_jual": snapshot.data[index]["harga_jual"].toString(),
                                                          "qty": _numbarang![index].toString(),
                                                        };
                                                        Fluttertoast.showToast(msg: _numbarang![index].toString());
                                                      } else if (!_selected![index]) {
                                                        _selectedBarang![index] = {
                                                          "nama_barang": "",
                                                          "harga_jual": "",
                                                          "qty": "",
                                                        };
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                Map<String, dynamic>? body;
                int ctr = 0;
                for (var element in _selectedBarang!) {
                  if (element["nama_barang"] != "") {
                    ctr++;
                  }
                }

                List<Map> listbarang = List.generate(ctr, (i) => {"nama_barang": "", "qty": "", "harga_jual": ""});

                ctr = 0;

                for (var element in _selectedBarang!) {
                  if (element["nama_barang"] != "") {
                    listbarang[ctr] = {
                      "nama_barang": element["nama_barang"],
                      "harga_jual": element["harga_jual"],
                      "qty": element["qty"],
                    };
                    ctr++;
                  }
                }

                body = {
                  'barang': listbarang,
                  'id_pelanggan': pelanggan!.dropDownValue!.value.toString(),
                  'status_ppn': statusppn!.dropDownValue!.value.toString(),
                  'tanggal_penjualan': tanggal.text.toString(),
                  'tanggal_tempo': tanggal_tempo.text.toString(),
                };
                if (title == "tambah") {
                  if (pelanggan!.dropDownValue!.name == "Pelanggan" || statusppn!.dropDownValue!.name == "Status PPN")
                    Fluttertoast.showToast(msg: "Silahkan pilih combobox");
                  else if (listbarang.length == 0) {
                    Fluttertoast.showToast(msg: "Silahkan pilih barang");
                  } else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _penjualan.add(body);
                  }
                } else {
                  if (pelanggan!.dropDownValue!.name == "Pelanggan" || statusppn!.dropDownValue!.name == "Status PPN")
                    Fluttertoast.showToast(msg: "Silahkan pilih combobox");
                  else if (listbarang.length == 0) {
                    Fluttertoast.showToast(msg: "Silahkan pilih barang");
                  } else {
                    var id = await getIdPenjualan(widget.index);
                    await _penjualan.doc(id).update(body);
                    Fluttertoast.showToast(msg: "Sukses update");
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
