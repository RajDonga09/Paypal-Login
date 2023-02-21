import 'package:flutter/material.dart';
import 'package:paypal_login_demo/paypal_controller.dart';
import 'package:paypal_login_demo/paypal_web_view.dart';

void main() {
  runApp(const MyApp());
}

GlobalKey<ScaffoldMessengerState> scaffoldState = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayPal Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scaffoldMessengerKey: scaffoldState,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PaypalController paypalController;

  @override
  void initState() {
    super.initState();
    paypalController = PaypalController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With PayPal'),
        centerTitle: true,
      ),
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: paypalController.isLoading,
            builder: (context, bool loading, child) {
              return loading
                  ? const CircularProgressIndicator()
                  : ValueListenableBuilder(
                      valueListenable: paypalController.isConnected,
                      builder: (context, bool connected, child) {
                        return connected
                            ? Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(paypalController.payPalResponse?.toJson().toString() ?? 'No Data'),
                            )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaypalWebView()));
                                },
                                child: Container(
                                  height: 58,
                                  width: 300,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(16)),
                                  child: const Text(
                                    'Connect Now',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                      });
            }),
      ),
    );
  }
}

void showSnackBar(String message) {
  scaffoldState.currentState!.showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
}
