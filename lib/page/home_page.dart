import 'dart:math' as math;
import 'package:kalkulator_bidang_datar/common/constans.dart';
import 'package:kalkulator_bidang_datar/common/styles.dart';
import 'package:kalkulator_bidang_datar/dialog/exit_dialog.dart';
import 'package:kalkulator_bidang_datar/dialog/info_dialog.dart';
import 'package:kalkulator_bidang_datar/tool/helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Helper _helper;
  late int _pos;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _c1;
  late TextEditingController _c2;
  double? _luas;
  double? _keliling;

  @override
  void initState() {
    super.initState();
    _helper = Helper();
    _pos = 0;
    _formKey = GlobalKey<FormState>();
    _c1 = TextEditingController();
    _c2 = TextEditingController();
  }

  void _onClear() {
    setState(() {
      _c1.clear();
      _c2.clear();
      _luas = null;
      _keliling = null;
    });
  }

  void _onCal() {
    double v1 = double.tryParse(_c1.text) ?? 0.0;
    double v2 = double.tryParse(_c2.text) ?? 0.0;

    setState(() {
      switch (_pos) {
        case 0:
          _luas = v1 * v2;
          _keliling = 2 * (v1 + v2);
          break;
        case 1:
          _luas = 1 / 2 * v1 * v2;
          _keliling = v1 * 3;
          break;
        case 2:
          _luas = math.pi * (v1 / 2);
          _keliling = math.pi * v1;
          break;
      }
    });
  }

  Future<bool> _onWillPop() async {
    bool exit = await openExitDialog(context) ?? false;
    return Future.value(exit);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kGAppName),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => openInfoDialog(context),
            )
          ],
        ),
        body: _buildBody(),
      ),
      onWillPop: _onWillPop,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _topNav(value: 0, title: "Persegi"),
              _topNav(value: 1, title: "Segitiga"),
              _topNav(value: 2, title: "Lingkaran"),
            ],
          ),
          const SizedBox(height: 32.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _field(
                  controller: _c1,
                  inputAction:
                      _pos != 2 ? TextInputAction.next : TextInputAction.done,
                  label: _pos == 0
                      ? "Panjang"
                      : _pos == 1
                          ? "Alas"
                          : "Diameter",
                  hint:
                      "Masukkan ${_pos == 0 ? "Panjang" : _pos == 1 ? "Alas" : "Diameter"}",
                ),
                if (_pos != 2) const SizedBox(height: 16.0),
                if (_pos != 2)
                  _field(
                    controller: _c2,
                    inputAction: TextInputAction.done,
                    label: _pos == 0 ? "Lebar" : "Tinggi",
                    hint: "Masukkan ${_pos == 0 ? "Lebar" : "Tinggi"}",
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          _button(title: "Clear", onTap: _onClear),
          _button(title: "Hitung", onTap: _onCal),
          if (_luas != null)
            Column(
              children: [
                const SizedBox(height: 24.0),
                _result(
                  title: "Luas",
                  rumus: _pos == 0
                      ? "Panjang × Lebar"
                      : _pos == 1
                          ? "1/2 × Alas × Tinggi"
                          : "π × (Diameter / 2)²",
                  hasil: _pos == 0
                      ? "${_c1.text} × ${_c2.text} = $_luas"
                      : _pos == 1
                          ? "1/2 × ${_c1.text} × ${_c2.text} = $_luas"
                          : "${math.pi} × (${_c1.text} / 2)² = $_luas",
                ),
                _result(
                  title: "Keliling",
                  rumus: _pos == 0
                      ? "2 × (Panjang + Lebar)"
                      : _pos == 1
                          ? "Sisi + Sisi + Sisi"
                          : "π × Diameter",
                  hasil: _pos == 0
                      ? "2 × (${_c1.text} + ${_c2.text}) = $_keliling"
                      : _pos == 1
                          ? "${_c1.text} + ${_c1.text} + ${_c1.text} = $_keliling"
                          : "${math.pi} × ${_c1.text} = $_keliling",
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _topNav({required int value, required String title}) {
    return MaterialButton(
      child: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(value == 0 ? 12.0 : 0.0),
          right: Radius.circular(value == 2 ? 12.0 : 0.0),
        ),
      ),
      color: _pos == value ? primaryColor : Colors.grey[300],
      textColor: _pos == value ? Colors.white : Colors.black,
      onPressed: () => setState(() {
        _onClear();
        _pos = value;
      }),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required TextInputAction inputAction,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      validator: (s) => s!.isEmpty
          ? "Kolom Wajib Diisi!"
          : !_helper.isNumeric(s)
              ? "Masukan harus berupa angka!"
              : null,
      keyboardType: TextInputType.number,
      textInputAction: inputAction,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
    );
  }

  Widget _button({required String title, Function()? onTap}) {
    return MaterialButton(
      child: Text(title),
      minWidth: double.infinity,
      color: primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: primaryColor,
          width: 2.0,
        ),
      ),
      onPressed: onTap,
    );
  }

  Widget _result({
    required String title,
    required String rumus,
    required String hasil,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rumus : ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(child: Text(rumus)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hasil : ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(child: Text(hasil)),
          ],
        ),
      ],
    );
  }
}
