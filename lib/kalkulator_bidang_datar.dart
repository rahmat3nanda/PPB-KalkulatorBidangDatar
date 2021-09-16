import 'package:kalkulator_bidang_datar/common/configs.dart';
import 'package:kalkulator_bidang_datar/common/constans.dart';
import 'package:kalkulator_bidang_datar/common/styles.dart';
import 'package:kalkulator_bidang_datar/page/splash_page.dart';
import 'package:flutter/material.dart';

class KalkulatorBidangDatar extends StatelessWidget {
  const KalkulatorBidangDatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kGAppName,
      theme: tdMain,
      localizationsDelegates: kLDelegates,
      supportedLocales: kLSupports,
      home: const SplashPage(),
    );
  }
}