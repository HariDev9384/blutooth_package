import '../utils/common.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DiscoveredDevice> devices = [];
  Map<String, DateTime> lastSeenMap = {};

  void addOrUpdateDevice(DiscoveredDevice newDevice) {
    // Check if the device already exists in the list
    int existingDeviceIndex = devices.indexWhere(
      (device) => device.id == newDevice.id,
    );

    // Update the last seen time for the device
    lastSeenMap[newDevice.id] = DateTime.now();

    if (existingDeviceIndex == -1) {
      // Device not found, check if it's connectable before adding
      if (newDevice.name.isNotEmpty) {
        setState(() {
          devices.add(newDevice);
        });
      }
    } else {
      // Device found, update it in the list
      setState(() {
        devices[existingDeviceIndex] = newDevice;
      });
    }
  }

  void removeOldDevices() {
    final now = DateTime.now();
    final devicesToRemove = <String>[];

    // Check devices' last seen time and add those that have not been seen for a while to the list to remove
    lastSeenMap.forEach((deviceId, lastSeen) {
      if (now.difference(lastSeen).inSeconds > 10) {
        devicesToRemove.add(deviceId);
      }
    });

    // Remove the devices from the list
    setState(() {
      devices.removeWhere((device) => devicesToRemove.contains(device.id));
      devicesToRemove.forEach(lastSeenMap.remove); // Remove from the lastSeenMap
    });
  }

  void scan() async {
    FlutterReactiveBle().scanForDevices(withServices: []).listen((event) {
      print(event.name.toString());
      addOrUpdateDevice(event);
    });
  }

  @override
  void initState() {
    scan();

    // Periodically remove old devices (e.g., every 10 seconds)
    Timer.periodic(const Duration(seconds: 10), (_) {
      removeOldDevices();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Devices ',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondary,
            fontFamily: 'Lexend'
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              shadowColor: Theme.of(context).colorScheme.primary,
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  devices.elementAt(index).name,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend'
                  ),
                ),
                SizedBox(height: 10), // Add space of 4 logical pixels between title and subtitle
              ],
            ),
                
                subtitle: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          devices.elementAt(index).id,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontFamily: 'Lexend',
                          ),
                        ),
                        Row(
                          children: [
                            Text('RSSI :',
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.bold
                            ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              devices.elementAt(index).rssi.toString(),
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontFamily: 'Lexend',
                          ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
