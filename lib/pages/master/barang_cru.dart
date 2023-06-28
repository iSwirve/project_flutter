import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class barang_cru extends StatefulWidget {
  final edit;
  final index;

  barang_cru({super.key, this.edit, this.index});

  static const routeName = '/barang';

  @override
  State<barang_cru> createState() => _barang_cruState();
}

class _barang_cruState extends State<barang_cru> {
  TextEditingController nama = TextEditingController();
  SingleValueDropDownController? brand;
  SingleValueDropDownController? kategori_barang;
  SingleValueDropDownController? supplier;
  TextEditingController stok_minimum = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController harga_beli = TextEditingController();
  TextEditingController harga_jual = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  Map<dynamic, dynamic> BrandData = {};
  Map<dynamic, dynamic> KategoriData = {};
  Map<dynamic, dynamic> SupplierData = {};
  var title = "Tambah";

  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Brand');
  CollectionReference _collectionRef2 = FirebaseFirestore.instance.collection('Kategori');
  CollectionReference _collectionRef3 = FirebaseFirestore.instance.collection('Barang');
  CollectionReference _collectionRef4 = FirebaseFirestore.instance.collection('Supplier');

  getdata() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    QuerySnapshot querySnapshot2 = await _collectionRef2.get();
    QuerySnapshot querySnapshot3 = await _collectionRef3.get();
    QuerySnapshot querySnapshot4 = await _collectionRef4.get();

    final allData = querySnapshot3.docs.map((doc) => doc.data()).toList();
    var ctr = 0;

    querySnapshot.docs.forEach((element) {
      BrandData[element.id] = querySnapshot.docs[ctr]["name"].toString();
      ctr++;
    });
    ctr = 0;
    querySnapshot2.docs.forEach((element) {
      KategoriData[element.id] = querySnapshot2.docs[ctr]["name"].toString();
      ctr++;
    });
    ctr = 0;
    querySnapshot4.docs.forEach((element) {
      SupplierData[element.id] = querySnapshot4.docs[ctr]["nama_supplier"].toString();
      ctr++;
    });

    return allData;
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
          "Master Barang - $title",
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
                builder: (context) => barang(),
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
                      nama.text = snapshot.data[widget.index]["nama_barang"] ?? '-';
                      stok_minimum.text = (snapshot.data[widget.index]["stok_minimum"] ?? 0).toString();
                      harga_beli.text = (snapshot.data[widget.index]["harga_beli"] ?? 0).toString();
                      harga_jual.text = (snapshot.data[widget.index]["harga_jual"] ?? 0).toString();
                      keterangan.text = snapshot.data[widget.index]["keterangan"] ?? "-";
                    }
                  }
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: nama,
                            hintText: "Nama",
                            title: "Nama",
                          ),
                          CustomDropdown(
                            title: "Brand",
                            list: BrandData,
                            controller: brand = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Brand",
                                value: "Brand",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Kategori Barang",
                            list: KategoriData,
                            controller: kategori_barang = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Kategori Barang",
                                value: "Kategori Barang",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Supplier",
                            list: SupplierData,
                            controller: supplier = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Supplier",
                                value: "Supplier",
                              ),
                            ),
                          ),
                          CustomTextField(
                            text_controller: stok_minimum,
                            hintText: "Stok Minimum",
                            title: "Stok Minimum",
                          ),
                          CustomTextField(
                            text_controller: harga_beli,
                            hintText: "Harga Beli",
                            title: "Harga Beli",
                          ),
                          CustomTextField(
                            text_controller: harga_jual,
                            hintText: "Harga Jual",
                            title: "Harga Jual",
                          ),
                          CustomTextField(
                            custom_maxline_size: 3,
                            text_controller: keterangan,
                            hintText: "Keterangan",
                            title: "Keterangan",
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
                  'brand': brand!.dropDownValue!.value.toString(),
                  'kategori_barang': kategori_barang!.dropDownValue!.value.toString(),
                  'nama_barang': nama.text.toString(),
                  'harga_beli': harga_beli.text.toString(),
                  'harga_jual': harga_jual.text.toString(),
                  'kode_supplier': supplier!.dropDownValue!.value.toString(),
                  'keterangan': keterangan.text.toString(),
                  'stok_minimum': stok_minimum.text.toString(),
                };

                if (title == "Tambah") {
                  if (nama.text.isEmpty)
                    Fluttertoast.showToast(msg: "Nama barang tidak boleh kosong");
                  else {
                    Fluttertoast.showToast(msg: "Sukses Insert");
                    await _collectionRef3.add(body);
                  }
                } else {
                  var id = await getId(widget.index);
                  await _collectionRef3.doc(id).update(body);
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
