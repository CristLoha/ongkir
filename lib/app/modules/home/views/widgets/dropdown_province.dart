import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ongkir/app/modules/home/controllers/home_controller.dart';
import '../../province_model.dart';

class Provinsi extends GetView<HomeController> {
  final String tipe;
  const Provinsi({
    Key? key,
    required this.tipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: DropdownSearch<ProvinceModel>(
        showClearButton: true,
        label: tipe == 'asal' ? 'Provinsi Asal' : 'Provinsi Tujuan',
        onFind: (String filter) async {
          Uri url = Uri.parse(
            'https://api.rajaongkir.com/starter/province',
          );

          try {
            final response = await http.get(
              url,
              headers: {
                'key': 'be7f266ea8eda45d1f95f085e6e7979e',
              },
            );

            var data = json.decode(response.body) as Map<String, dynamic>;
            var statusCode = data['rajaongkir']['status']['code'];

            if (statusCode != 200) {
              throw data['rajaongkir']['status']['code'];
            }

            var listAllProvince =
                data['rajaongkir']["results"] as List<dynamic>;

            var models = ProvinceModel.fromJsonList(listAllProvince);

            return models;
          } catch (err) {
            print(err);
            return List<ProvinceModel>.empty();
          }
        },
        onChanged: (prov) {
          if (prov != null) {
            if (tipe == 'asal') {
              controller.hiddenAsalKota.value = false;
              controller.provAsalId.value = int.parse(prov.provinceId!);
            } else {
              controller.hiddenTujuanKota.value = false;
              controller.provTujuanId.value = int.parse(prov.provinceId!);
            }
          } else {
            if (tipe == 'asal') {
              controller.hiddenAsalKota.value = true;
              controller.provAsalId.value = 0;
            } else {
              controller.hiddenTujuanKota.value = true;
              controller.provTujuanId.value = 0;
            }
          }
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: 'cari provinsi...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              50,
            ),
          ),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              '${item.province}',
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => item.province!,
      ),
    );
  }
}
