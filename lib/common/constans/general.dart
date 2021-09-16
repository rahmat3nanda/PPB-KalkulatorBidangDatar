const kGAppName = "Kalkulator Bidang Datar";
const kGPackageName = "id.nesd.kalkulator_bidang_datar";
const kGVersionName = "1.0.0";
const kGVersionCode = 1;

String kGLogTag = "[$kGAppName]";
const kGLogEnable = true;

void printLog(dynamic data) {
  if (kGLogEnable) {
    print("[${DateTime.now().toUtc()}]$kGLogTag$data");
  }
}
