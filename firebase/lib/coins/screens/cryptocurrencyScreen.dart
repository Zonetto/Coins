import 'dart:convert';
import 'package:firebase/coins/model/coins.dart';
import 'package:firebase/coins/screens/currencyMovementScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/coins/widget/stateless.dart' as coin;
import 'package:http/http.dart' as http;

class CryptocurrencyScreen extends StatefulWidget {
  const CryptocurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CryptocurrencyScreen> createState() => _CryptocurrencyScreenState();
}

class _CryptocurrencyScreenState extends State<CryptocurrencyScreen> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd',
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> res = [];
      res = await json.decode(response.body);
      if (res.isNotEmpty) {
        for (int i = 0; i < res.length; i++) {
          if (res[i] != null) {
            Map<String, dynamic> map = res[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        if (mounted) {
          setState(() {
            coinList;
          });
        }
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  @override
  void initState() {
    fetchCoin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async => await fetchCoin(),
        child: ListView(
          children: coinList
              .map(
                (e) => CupertinoButton(
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrencyMovement(
                          image: e.imageUrl,
                          name: e.name,
                          symbol: e.symbol.toLowerCase(),
                          btcUsdtPrice: e.price.toString(),
                        ),
                      ),
                    );
                  },
                  child: coin.CoinCard(
                    imageUrl: e.imageUrl,
                    name: e.name,
                    symbol: e.symbol,
                    price: e.price.toDouble(),
                    change: e.change.toDouble(),
                    changePercentage: e.changePercentage.toDouble(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
