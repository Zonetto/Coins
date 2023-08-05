import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import 'package:intl/intl.dart' as intl;
import 'package:firebase/style/color.dart' as color;

class CurrencyMovement extends StatefulWidget {
  String name;
  String image;
  String symbol;
  String btcUsdtPrice;
  var snap;

  CurrencyMovement({
    Key? key,
    required this.name,
    required this.image,
    required this.symbol,
    required this.btcUsdtPrice,
    this.snap,
  }) : super(key: key);

  @override
  State<CurrencyMovement> createState() => _CurrencyMovementState();
}

class _CurrencyMovementState extends State<CurrencyMovement> {
  String btcUsdtPrice = "0";
  String percent = "0";
  String volume = "0";
  String high = "0";
  String low = "0";
  @override
  void initState() {
    super.initState();
    dataStream();
  }

  dataStream() async {
    final channel = IOWebSocketChannel.connect(
      "wss://stream.binance.com:9443/ws/${widget.symbol}usdt@ticker",
    );
    channel.stream.listen((message) {
      var getData = jsonDecode(message);
      if (mounted) {
        setState(() {
          if (getData != null) {
            btcUsdtPrice = getData['c'];
            percent = getData['P'];
            volume = getData['v'];
            high = getData['h'];
            low = getData['l'];
          }
        });
      }
    });
  }

  @override
  void dispose() {
    dataStream();
    super.dispose();
  }

  double sizeText = 22.0;
  final double sizeTextNumber = 20.0;
  @override
  Widget build(BuildContext context) {
    final fmt = intl.NumberFormat("0.##", "en_US");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color.appBarBackgroundColor,
        title: Text(widget.name),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.white12,
                        offset: Offset(-4, -4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 80.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              radius: 35.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      color: Colors.white10,
                                      offset: Offset(-4, -4),
                                    )
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(widget.image),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "\$${intl.NumberFormat.decimalPattern().format(double.parse(btcUsdtPrice))}",
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF5C6BC0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Volume",
                                  style: TextStyle(
                                    fontSize: sizeText,
                                    color: color.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  intl.NumberFormat.decimalPattern()
                                      .format(double.parse(volume)),
                                  style: TextStyle(
                                    fontSize: sizeTextNumber,
                                    color: color.textColorNumber,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Change percent",
                                  style: TextStyle(
                                    fontSize: sizeText,
                                    color: color.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Container(
                                  height: 25.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: double.parse(percent) > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        double.parse(percent) > 0
                                            ? Icons.arrow_drop_up_outlined
                                            : Icons.arrow_drop_down_outlined,
                                        color: Colors.white,
                                      ),
                                      // SizedBox(
                                      //   width: 10.0,
                                      // ),
                                      Text(
                                        "${fmt.format(double.parse(percent).abs())}%",
                                        style: TextStyle(
                                          fontSize: sizeTextNumber,
                                          color: color.textColorNumber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF5C6BC0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "24hr high",
                                  style: TextStyle(
                                    fontSize: sizeText,
                                    color: color.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "\$${intl.NumberFormat.decimalPattern().format(double.parse(high))}",
                                  style: TextStyle(
                                    fontSize: sizeTextNumber,
                                    color: color.textColorNumber,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                Text(
                                  "24hr low",
                                  style: TextStyle(
                                    fontSize: sizeText,
                                    color: color.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "\$${intl.NumberFormat.decimalPattern().format(double.parse(low))}",
                                  style: TextStyle(
                                    fontSize: sizeTextNumber,
                                    color: color.textColorNumber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
