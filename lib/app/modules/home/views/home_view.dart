import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

import 'widgets/dropdown_city.dart';
import 'widgets/dropdown_province.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Provinsi(tipe: 'asal'),
          Obx(
            () => controller.hiddenAsalKota.isTrue
                ? SizedBox()
                : Kota(
                    provId: controller.provAsalId.value,
                    tipe: 'asal',
                  ),
          ),
          Provinsi(tipe: 'tujuan'),
          Obx(
            () => controller.hiddenTujuanKota.isTrue
                ? SizedBox()
                : Kota(
                    provId: controller.provTujuanId.value,
                    tipe: 'tujuan',
                  ),
          ),
        ],
      ),
    );
  }
}
