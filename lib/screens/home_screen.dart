import 'package:firebase/provider/auth.dart';
import 'package:firebase/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cryptocurrency_screen.dart';
import 'package:firebase/style/color.dart' as color;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                title: const Text("Log out"),
                content: const Text(
                  "Do you want to continue the logout process?",
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        defaultButton(
                          context: context,
                          function: () {
                            Navigator.pop(ctx);
                          },
                          text: 'Cancel',
                          widthMin: 80.0,
                          isMin: true,
                          height: 40.0,
                          textSize: 14.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        defaultButton(
                          context: context,
                          function: () {
                            Provider.of<Auth>(ctx, listen: false).logOut();
                            Navigator.pop(ctx);
                          },
                          text: 'Continue',
                          widthMin: 90.0,
                          isMin: true,
                          height: 40.0,
                          textSize: 14.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout),
        ),
        elevation: 0.0,
        backgroundColor: color.appBarBackgroundColor,
        title: const Text("Cryptocurrency"),
        centerTitle: true,
      ),
      body: const CryptocurrencyScreen(),
    );
  }
}
