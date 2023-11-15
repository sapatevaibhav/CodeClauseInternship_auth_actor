import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Authenticator',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableTypes = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _checkBiometric,
              child: const Text("Check for Biometric"),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Is Biometric Supported? $_canCheckBiometric",
              style: TextStyle(
                  color: _canCheckBiometric ? Colors.green : Colors.red),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _getListOfBiometricTypes,
              child: const Text("List Biometrics available"),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: Text(
                "List of available biometrics ${_availableTypes.toString()}",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Click here to authorize now",
            ),
            ElevatedButton(
              onPressed: _authorizeNow,
              child: const Text("Authorize Now"),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Authorized? $_authorizedOrNot",
              style: TextStyle(
                  color: _authorizedOrNot == "Authorized"
                      ? Colors.green
                      : Colors.red),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 100,
            ),
            const Text(
              "made by sapatevaibhav 🧡",
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics ||
          await _localAuthentication.isDeviceSupported();
    } on PlatformException {
      //
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics = List.empty();
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException {
      //
    }
    if (!mounted) return;
    setState(() {
      _availableTypes = listOfBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticate(
        localizedReason:
            "\n\nDear user this process is only for test purpose \n\nThe application needs to check for the biometrics",
      );
    } on PlatformException {
      //
    }
    if (!mounted) return;
    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });
  }
}
