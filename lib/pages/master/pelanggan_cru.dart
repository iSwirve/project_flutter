
import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class pelanggan_cru extends StatefulWidget {
  final edit;
  int? index;
  pelanggan_cru({super.key, this.edit, this.index});

  static const routeName = '/pelanggan';

  @override
  State<pelanggan_cru> createState() => _pelanggan_cruState();
}

class _pelanggan_cruState extends State<pelanggan_cru> {
  TextEditingController nama = TextEditingController();
  TextEditingController kode = TextEditingController();
  TextEditingController namapic = TextEditingController();
  TextEditingController telepon = TextEditingController();
  TextEditingController alamat_penagihan = TextEditingController();
  TextEditingController alamat_pengiriman = TextEditingController();
  TextEditingController npwp = TextEditingController();
  SingleValueDropDownController? status_pkp;
  TextEditingController jatuh_tempo = TextEditingController();
  SingleValueDropDownController? sales;
  TextEditingController kota = TextEditingController();
  TextEditingController keterangan_penjualan = TextEditingController();
  SingleValueDropDownController? ekspedisi;
  SingleValueDropDownController? kategori_pelanggan;
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
                      nama.text = snapshot.data["name"] ?? '-';
                      kode.text = snapshot.data["code"] ?? '-';
                      telepon.text = snapshot.data["phone"] ?? '-';
                      namapic.text = snapshot.data["pic_name"] ?? '-';
                      alamat_penagihan.text =
                          snapshot.data["billing_address"] ?? '-';
                      alamat_pengiriman.text =
                          snapshot.data["shipping_address"] ?? '-';
                      npwp.text = snapshot.data["tax_no"] ?? "-";
                      jatuh_tempo.text =
                          snapshot.data["sales_due_days"].toString();
                      kota.text = snapshot.data["city"] ?? "-";
                      keterangan_penjualan.text = "-";
                    }
                  }
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: nama,
                            hintText: "Nama pelanggan",
                            title: "Nama pelanggan",
                          ),
                          CustomTextField(
                            text_controller: kode,
                            hintText: "Kode",
                            title: "Kode",
                          ),
                          CustomTextField(
                            text_controller: namapic,
                            hintText: "Nama Pic",
                            title: "Nama Pic",
                          ),
                          CustomTextField(
                            text_controller: telepon,
                            hintText: "Telpon",
                            title: "Telpon",
                          ),
                          CustomTextField(
                            custom_maxline_size: 3,
                            text_controller: alamat_penagihan,
                            hintText: "Alamat Penagihan",
                            title: "Alamat Penagihan",
                          ),
                          CustomTextField(
                            custom_maxline_size: 3,
                            text_controller: alamat_pengiriman,
                            hintText: "Alamat Pengiriman",
                            title: "Alamat Pengiriman",
                          ),
                          CustomTextField(
                            text_controller: npwp,
                            hintText: "NPWP",
                            title: "NPWP",
                          ),
                          CustomDropdown(
                            title: "Status PKP",
                            list: {1: "Ya", 0: "Tidak"},
                            controller: status_pkp =
                                SingleValueDropDownController(
                              data: DropDownValueModel(name: "Ya", value: 1),
                            ),
                          ),
                          CustomTextField(
                            text_controller: jatuh_tempo,
                            hintText: "Jatuh Tempo",
                            title: "Jatuh Tempo",
                          ),
                          CustomDropdown(
                            title: "Sales",
                            list: SalesData,
                            controller: sales = SingleValueDropDownController(
                              data: DropDownValueModel(name: "-", value: "-"),
                            ),
                          ),
                          CustomTextField(
                            text_controller: kota,
                            hintText: "Kota",
                            title: "Kota",
                          ),
                          CustomTextField(
                            custom_maxline_size: 3,
                            text_controller: keterangan_penjualan,
                            hintText: "Keterangan Penjualan",
                            title: "Keterangan Penjualan",
                          ),
                          CustomDropdown(
                            title: "Ekspedisi",
                            list: EkspedisiData,
                            controller: ekspedisi =
                                SingleValueDropDownController(
                              data: DropDownValueModel(name: "-", value: "-"),
                            ),
                          ),
                          CustomDropdown(
                            title: "Kategori Pelanggan",
                            list: KategoriData,
                            controller: kategori_pelanggan =
                                SingleValueDropDownController(
                              data: DropDownValueModel(name: "-", value: "-"),
                            ),
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
                Map<dynamic, dynamic>? body;
                body = {
                  'customer_category_id': int.tryParse(
                    kategori_pelanggan!.dropDownValue!.value.toString(),
                  ),
                  'salesperson_id': int.tryParse(
                    sales!.dropDownValue!.value.toString(),
                  ),
                  'expedition_id': int.tryParse(
                    ekspedisi!.dropDownValue!.value.toString(),
                  ),
                  'taxpayer': status_pkp?.dropDownValue?.value,
                  'code': kode.text.toString(),
                  "name": nama.text.toString(),
                  'pic_name': namapic.text.toString(),
                  'phone': telepon.text.toString(),
                  'billing_address': alamat_penagihan.text.toString(),
                  'shipping_address': alamat_pengiriman.text.toString(),
                  'tax_no': npwp.text.toString(),
                  'city': kota.text.toString(),
                  'sales_due_days': int.tryParse(jatuh_tempo.text.toString()),
                };

                if (title == "Tambah") {
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
