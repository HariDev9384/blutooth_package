
import 'utils/common.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  requestLocationPermission().then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'blue',
      home: Home()
    );
  }
}

  // ask user permission

  Future<void> requestLocationPermission() async {
            var locationStatus = await Permission.location.request();
            var nearbyStatus = await  Permission.nearbyWifiDevices.request();
            await Permission.bluetoothScan.request();
            await Permission.bluetooth.request();
            await Permission.bluetoothAdvertise.request();
            await Permission.bluetoothConnect.request();
            if (locationStatus.isDenied||nearbyStatus.isDenied) {
              // Handle denied permission
            } else if (locationStatus.isPermanentlyDenied||nearbyStatus.isPermanentlyDenied) {
              // Handle permanently denied permission
            } else if (locationStatus.isGranted||nearbyStatus.isGranted) {
              // Permission is granted, proceed with Wi-Fi Direct interactions
            }
}