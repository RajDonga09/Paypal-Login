import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:paypal_login_demo/paypal_constant.dart';
import 'package:paypal_login_demo/paypal_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebView extends StatefulWidget {
  const PaypalWebView({Key? key}) : super(key: key);

  @override
  _PaypalWebViewState createState() => _PaypalWebViewState();
}

class _PaypalWebViewState extends State<PaypalWebView> {
  ValueNotifier<double> progress = ValueNotifier(0.0);
  late PaypalController paypalController;

  @override
  void initState() {
    super.initState();
    paypalController = PaypalController();
  }

  @override
  Widget build(BuildContext context) {
    print('PaypalConstant.requestUrl: ${PaypalConstant.requestUrl}');
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kToolbarHeight + 25,
            child: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              title: const Text(
                'Connecting to Paypal',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          ValueListenableBuilder(
            valueListenable: progress,
            builder: (context, double _progress, child) {
              return _progress < 1.0
                  ? LinearPercentIndicator(
                percent: _progress,
                lineHeight: 2,
                padding: cupertino.EdgeInsets.zero,
                progressColor: Colors.blue,
              )
                  : const SizedBox();
            },
          ),
          Expanded(
            child: Stack(
              children: [
                WebView(
                  initialUrl: PaypalConstant.requestUrl,
                  navigationDelegate: (NavigationRequest request) =>
                      paypalController.webViewInstagramCallBack(context, request),
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
                  onProgress: (int _progress) {
                    progress.value = (_progress / 100);
                  },
                  zoomEnabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
