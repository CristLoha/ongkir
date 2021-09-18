import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ongkir/app/modules/home/controllers/home_controller.dart';
import '../../city_model.dart';

class Kota extends GetView<HomeController> {
  final int provId;
  final String tipe;
  const Kota({
    Key? key,
    required this.provId,
    required this.tipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: DropdownSearch<CityModel>(
        showClearButton: true,
        label: tipe == 'asal'
            ? 'Kota / Kabupaten Asal'
            : 'Kota / Kabupaten Tujuan',
        onFind: (String filter) async {
          Uri url = Uri.parse(
            'https://api.rajaongkir.com/starter/city?province=$provId',
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

            var listAllCity = data['rajaongkir']["results"] as List<dynamic>;

            var models = CityModel.fromJsonList(listAllCity);

            return models;
          } catch (err) {
            print(err);
            return List<CityModel>.empty();
          }
        },
        onChanged: (cityValue) {
          if (cityValue != null) {
            if (tipe == 'asal') {
              controller.kotaAsalId.value = int.parse(cityValue.provinceId!);
            } else {
              controller.kotaTujuanId.value = int.parse(cityValue.provinceId!);
            }
          } else {
            if (tipe == 'asal') {
              print('Tidak memilih kota / kabupaten asal apapun');
            } else {
              print('Tidak memilih kota / kabupaten tujuan apapun');
            }
          }

          if (cityValue != null) {
            print(cityValue.cityName);
          } else {
            print('Tidak memilih kota / kabupaten apapun');
          }
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: 'cari kota / kabupaten...',
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
              '${item.type} ${item.cityName}',
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => '${item.type} ${item.cityName}',
      ),
    );
  }
}
