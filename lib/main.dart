
import 'utils/common.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request().then(
    (v){
        runApp(const MyApp());
    }
  );
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
