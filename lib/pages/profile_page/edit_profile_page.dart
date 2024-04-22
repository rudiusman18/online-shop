import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tokoSM/models/wilayah_model.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameTextField = TextEditingController();
  TextEditingController fullnameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController telpTextField = TextEditingController();
  TextEditingController alamatTextField = TextEditingController();
  TextEditingController wilayahTextField = TextEditingController();
  TextEditingController tglLahirTextField = TextEditingController();
  TextEditingController jenisKelaminTextField = TextEditingController();

// Wilayah Controller
  WilayahModel wilayah = WilayahModel();
  TextEditingController searchTextFieldController =
      TextEditingController(text: "");
  FocusNode searchTextFieldFocusNode = FocusNode();
  List<String> textDatabase = [];
  List<String> textSuggestion = [];

// DatePicker
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        tglLahirTextField.text = _selectedDate.split(" ").first;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget customtextFormField({
      required IconData icon,
      required String title,
      required TextInputType keyboardType,
      required TextEditingController controller,
      bool readOnly = false,
    }) {
      return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: poppins.copyWith(
                fontWeight: medium,
                fontSize: 14,
                color: backgroundColor1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              onTap: () {
                if (title.toLowerCase().contains("jenis kelamin")) {
                  CustomDropdown<String>(
                    hintText: '...',
                    items: const ["Laki-Laki", "Perempuan"],
                    onChanged: (value) {
                      jenisKelaminTextField.text = value;
                    },
                  );
                }
              },
              readOnly: readOnly,
              textInputAction: TextInputAction.next,
              style: poppins.copyWith(
                color: backgroundColor1,
              ),
              keyboardType: keyboardType,
              cursorColor: backgroundColor1,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintText: "...",
                hintStyle: poppins.copyWith(
                  color: backgroundColor1,
                ),
                prefixIcon: Icon(icon),
                prefixIconColor: backgroundColor1,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor1,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor3,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget getWilayah({required WilayahModel wilayah}) {
      print("isi wilayahnya adalah: ${wilayah.data?.first.name}");

      return StatefulBuilder(
        builder: (context, stateSetter) {
          return Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  stateSetter(() {
                    print(
                        "search object: ${searchTextFieldController.text} dengan ${value.toLowerCase()}");
                    textSuggestion.clear();
                    textSuggestion = textDatabase
                        .where((element) =>
                            element.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                    print("isi listnya adalah $textSuggestion");
                  });
                },
                textInputAction: TextInputAction.search,
                controller: searchTextFieldController,
                cursorColor: backgroundColor1,
                focusNode: searchTextFieldFocusNode,
                decoration: InputDecoration(
                  hintText: "Cari Barang",
                  hintStyle: poppins,
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchTextFieldFocusNode.hasFocus
                      ? backgroundColor1
                      : Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundColor1, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < textSuggestion.length; i++)
                      Text("${textSuggestion[i]}"),
                  ],
                ),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Profil",
            style: poppins,
          ),
          backgroundColor: backgroundColor3,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            customtextFormField(
              icon: Icons.person,
              title: "Nama Pengguna",
              keyboardType: TextInputType.name,
              controller: usernameTextField,
            ),
            customtextFormField(
              icon: Icons.person,
              title: "Nama Lengkap",
              keyboardType: TextInputType.name,
              controller: fullnameTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Email",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.phone,
              title: "Telp",
              keyboardType: TextInputType.phone,
              controller: telpTextField,
            ),
            customtextFormField(
              icon: Icons.house,
              title: "Alamat",
              keyboardType: TextInputType.streetAddress,
              controller: alamatTextField,
            ),

            // NOTE: wilayah
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Wilayah",
                style: poppins.copyWith(
                  fontWeight: medium,
                  color: backgroundColor1,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: backgroundColor1,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Icon(
                      Icons.map_rounded,
                      size: 25,
                      color: backgroundColor1,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        String data =
                            await rootBundle.loadString('assets/wilayah.json');
                        var jsonResult = jsonDecode(data);
                        wilayah = WilayahModel.fromJson(jsonResult);
                        setState(() {
                          textDatabase = wilayah.data
                                  ?.map((e) => (e.value) ?? "")
                                  .toList() ??
                              [];
                          textSuggestion = textDatabase;
                        });
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: MediaQuery.sizeOf(context).width,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: getWilayah(wilayah: wilayah),
                                ),
                              );
                            });
                      },
                      child: Text(
                        tglLahirTextField.text == ""
                            ? "..."
                            : tglLahirTextField.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NOTE: Tanggal lahir
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Tanggal Lahir",
                style: poppins.copyWith(
                  fontWeight: medium,
                  color: backgroundColor1,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: backgroundColor1,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Icon(
                      Icons.date_range,
                      size: 25,
                      color: backgroundColor1,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: MediaQuery.sizeOf(context).width,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: SfDateRangePicker(
                                    initialSelectedDate: DateTime.tryParse(
                                      tglLahirTextField.text,
                                    ),
                                    onSelectionChanged: _onSelectionChanged,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now()
                                            .subtract(const Duration(days: 4)),
                                        DateTime.now()
                                            .add(const Duration(days: 3))),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text(
                        tglLahirTextField.text == ""
                            ? "..."
                            : tglLahirTextField.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NOTE: Jenis Kelamin
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Jenis Kelamin",
                style: poppins.copyWith(
                  fontWeight: medium,
                  color: backgroundColor1,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: backgroundColor1,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.man,
                      size: 25,
                      color: backgroundColor1,
                    ),
                  ),
                  Expanded(
                    child: CustomDropdown<String>(
                      hintText: '...',
                      items: const ["Laki-Laki", "Perempuan"],
                      onChanged: (value) {
                        jenisKelaminTextField.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
