import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/city_model.dart';
import '../../../data/models/province_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final homeC = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Widget dropDownProvince() {
      return DropdownSearch<Province>(
        showSearchBox: true,
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title: Text('${item.province}'),
        ),
        dropdownSearchDecoration: const InputDecoration(
          labelText: 'Provinsi Asal',
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(),
        ),
        onFind: (text) async {
          var response = await Dio().get(
            "https://api.rajaongkir.com/starter/province",
            queryParameters: {
              "key": "f6a507236cba287753346bcdf7e5379f",
            },
          );
          return Province.fromJsonList(response.data["rajaongkir"]["results"]);
        },
        onChanged: (value) =>
            controller.provinceAsalId.value = value?.provinceId ?? "0",
      );
    }

    Widget dropDownCity() {
      return DropdownSearch<City>(
        showSearchBox: true,
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title: Text('${item.type} ${item.cityName}'),
        ),
        dropdownSearchDecoration: const InputDecoration(
          labelText: 'Kota/Kab Asal',
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(),
        ),
        onFind: (text) async {
          var response = await Dio().get(
            "https://api.rajaongkir.com/starter/city?province=${controller.provinceAsalId}",
            queryParameters: {
              "key": "f6a507236cba287753346bcdf7e5379f",
            },
          );
          return City.fromJsonList(response.data["rajaongkir"]["results"]);
        },
        onChanged: (value) =>
            controller.cityAsalId.value = value?.cityId ?? "0",
      );
    }

    Widget dropDownDestinationProvince() {
      return DropdownSearch<Province>(
        showSearchBox: true,
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title: Text('${item.province}'),
        ),
        dropdownSearchDecoration: const InputDecoration(
          labelText: 'Provinsi Asal',
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(),
        ),
        onFind: (text) async {
          var response = await Dio().get(
            "https://api.rajaongkir.com/starter/province",
            queryParameters: {
              "key": "f6a507236cba287753346bcdf7e5379f",
            },
          );
          return Province.fromJsonList(response.data["rajaongkir"]["results"]);
        },
        onChanged: (value) =>
            controller.provinceTujuanId.value = value?.provinceId ?? "0",
      );
    }

    Widget dropDownDestinationCity() {
      return DropdownSearch<City>(
        showSearchBox: true,
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title: Text('${item.type} ${item.cityName}'),
        ),
        dropdownSearchDecoration: const InputDecoration(
          labelText: 'Kota/Kab Asal',
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(),
        ),
        onFind: (text) async {
          var response = await Dio().get(
            "https://api.rajaongkir.com/starter/city?province=${controller.provinceTujuanId}",
            queryParameters: {
              "key": "f6a507236cba287753346bcdf7e5379f",
            },
          );
          return City.fromJsonList(response.data["rajaongkir"]["results"]);
        },
        onChanged: (value) =>
            controller.cityTujuanId.value = value?.cityId ?? "0",
      );
    }

    Widget weight() {
      return TextField(
          autocorrect: false,
          keyboardType: TextInputType.number,
          controller: controller.beratC,
          decoration: const InputDecoration(
            labelText: 'Berat (gram)',
            contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            border: OutlineInputBorder(),
          ));
    }

    Widget dropdownChooseCourier() {
      return DropdownSearch<Map<String, dynamic>>(
        showSearchBox: true,
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title: Text('${item['name']}'),
        ),
        dropdownSearchDecoration: const InputDecoration(
          labelText: 'Pilih Kurir',
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(),
        ),
        dropdownBuilder: (context, selectedItem) =>
            Text('${selectedItem?['name'] ?? 'Pilih Kurir'}'),
        onChanged: (value) => controller.codeKurir.value = value?['code'] ?? "",
        // onFind: (text) => const Text('data'),
        items: const [
          {
            "code": "jne",
            "name": "JNE",
          },
          {
            "code": "pos",
            "name": "POS INDONESIA",
          },
          {
            "code": "tiki",
            "name": "TIKI INDONESIA",
          },
        ],
      );
    }

    Widget buttonCheckPostage() {
      return Obx(
        () => ElevatedButton(
          onPressed: () {
            if (controller.isLoading.isFalse) {
              controller.cekOngkir();
            }
          },
          child: Text(controller.isLoading.isFalse
              ? 'Cek Ongkos Kirim'
              : 'Loading ...'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongkos Kirim'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          dropDownProvince(),
          const SizedBox(
            height: 10,
          ),
          dropDownCity(),
          const SizedBox(
            height: 30,
          ),
          dropDownDestinationProvince(),
          const SizedBox(
            height: 10,
          ),
          dropDownDestinationCity(),
          const SizedBox(
            height: 30,
          ),
          weight(),
          const SizedBox(
            height: 30,
          ),
          dropdownChooseCourier(),
          const SizedBox(
            height: 30,
          ),
          buttonCheckPostage()
        ],
      ),
    );
  }
}
