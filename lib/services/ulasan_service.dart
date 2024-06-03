import "dart:convert";

import "package:flutter/material.dart";
import "package:tokoSM/models/ulasan_model.dart";
import "package:http/http.dart" as http;

class UlasanService {
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<UlasanModel> retrieveRiwayatUlasan({required String token}) async {
    var url = Uri.parse("${baseURL}ulasan");
    print("URL yang diakses adalah: ${url}");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Ulasan: ${response.body}");

// **success mendapatkan data ulasan
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      UlasanModel ulasan = UlasanModel.fromJson(data);
      return ulasan;
    } else {
      throw Exception("Gagal mendapatkan data riwayat ulasan");
    }
  }
}