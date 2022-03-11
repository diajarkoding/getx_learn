import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkosKirim = [];

  RxBool isLoading = false.obs;

  RxString provinceTujuanId = "0".obs;
  RxString provinceAsalId = "0".obs;
  RxString cityTujuanId = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString codeKurir = "".obs;

  void cekOngkir() async {
    if (provinceAsalId.value != "0" &&
        provinceTujuanId.value != "0" &&
        cityAsalId.value != "0" &&
        cityTujuanId.value != "0" &&
        codeKurir.value != "" &&
        beratC.text != "") {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse("https://api.rajaongkir.com/starter/cost"),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
          "key": "f6a507236cba287753346bcdf7e5379f",
        },
        body: {
          "origin": cityAsalId.value,
          "destination": cityTujuanId.value,
          "weight": beratC.text,
          "courier": codeKurir.value,
        },
      );
      isLoading.value = false;
      List ongkir = json.decode(response.body)["rajaongkir"]["results"][0]
          ["costs"] as List;
      ongkosKirim = Ongkir.fromJsonList(ongkir);

      Get.defaultDialog(
          title: "Ongkos Kirim",
          content: Column(
              children: ongkosKirim
                  .map((e) => ListTile(
                      title: Text(e.service!.toUpperCase()),
                      subtitle: Text("${e.cost![0].value}")))
                  .toList()));
    } else {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Data input belum lengkap");
    }
  }
}
