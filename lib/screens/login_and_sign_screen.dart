import 'package:firebase/widget/widget.dart';
import 'package:firebase/provider/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/style/color.dart' as color;

enum AuthMode { SignUp, Login }

class Keys {
  static final GlobalKey<FormState> _formKey = GlobalKey();
  static final GlobalKey<FormState> _formKey2 = GlobalKey();
}

class LoginAndSignScreen extends StatefulWidget {
 const LoginAndSignScreen({Key? key}) : super(key: key);

  @override
  State<LoginAndSignScreen> createState() => _SignInAndASignUpState();
}

class _SignInAndASignUpState extends State<LoginAndSignScreen> {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  bool _isCheckSigIn = true;
  String? user;

  Future<void> _submitSignUp() async {
    if (!Keys._formKey2.currentState!.validate()) {
      // Invalid!
      return;
    }

    Keys._formKey2.currentState!.save();
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    try {
      // Sign user up
      await Provider.of<Auth>(context, listen: false)
          .signUp(_authData['email']!, _authData['password']!, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          padding: EdgeInsets.all(10.0),
          backgroundColor: Colors.white,
          elevation: 10,
          content: Text(
            "E-mail found",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
          ),
        ),
      );
    }

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  Future<void> _submitSigIn() async {
    var provider = Provider.of<Auth>(context, listen: false);
    if (!Keys._formKey.currentState!.validate()) {
      return;
    }
    Keys._formKey.currentState!.save();
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    try {
      // Log user in
      await provider.logIn(
          _authData['email']!, _authData['password']!, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: color.appBarBackgroundColor,
          content: const Text(
            "Email and password are not correct",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    }
    //AuthController.AuthController.login(_authData, context);
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  void init() {
    passwordController.text = "";
    emailController.text = "";
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.SignUp) {
      if (mounted) {
        setState(() {
          _authMode = AuthMode.Login;
          init();
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _authMode = AuthMode.SignUp;
          init();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C6BC0),
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white, //Color(0xFF5C6BC0)
      ),
      body: Builder(
        builder: (context) => Form(
          key: Keys._formKey,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              color: color.loginScreenBackgroundColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Image.asset("assets/images/iconEthereum96.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              //vertical: 10.0,
                              ),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Enter your email',
                              hintText: 'ex: test@gmail.com',
                            ),
                            style: const TextStyle(fontSize: 16.0),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _authData['email'] = value;
                            },
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isCheckSigIn,
                            decoration: InputDecoration(
                              suffixIcon: CupertinoButton(
                                  onPressed: () {
                                    if (mounted)
                                      setState(() {
                                        _isCheckSigIn
                                            ? _isCheckSigIn = false
                                            : _isCheckSigIn = true;
                                      });
                                  },
                                  pressedOpacity: 0.9,
                                  padding: const EdgeInsets.all(0.0),
                                  child: const Text("Show")),
                              labelText: 'Enter your password',
                            ),
                            style: const TextStyle(fontSize: 16.0),
                            validator: (value) {
                              if (value!.length <= 6 || value.isEmpty) {
                                return 'Your password must be larger than 6 characters';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _authData['password'] = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : defaultButton(
                                context: context,
                                function: _submitSigIn,
                                text: _authMode == AuthMode.Login
                                    ? "LOGIN"
                                    : "SIGN UP",
                              ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultButton(
                          context: context,
                          text:
                              _authMode != AuthMode.Login ? "LOGIN" : "SIGN UP",
                          function: () {
                            _switchAuthMode();
                            Scaffold.of(context).showBottomSheet<void>(
                              backgroundColor: const Color(0xFF5C6BC0),
                              (context) {
                                return bottomSheetCard(
                                  context,
                                  AuthMode.Login,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetCard(BuildContext context, authMode) {
    return Form(
      key: Keys._formKey2,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height / 2 + 100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'ex: test@gmail.com',
                  ),
                  style: const TextStyle(fontSize: 16.0),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _authData['email'] = value;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  //  key: _formKey,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter your password",
                  ),
                  style: const TextStyle(fontSize: 16.0),
                  validator: (value) {
                    if (value!.length < 8 || value.isEmpty) {
                      return 'Your password must be larger than 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _authData['password'] = value;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  controller: confirmController,
                  keyboardType: TextInputType.visiblePassword,
                  // enabled: authMode == AuthMode.SignUp,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Enter your Confirm Password",
                  ),
                  style: const TextStyle(fontSize: 16.0),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              defaultButton(
                context: context,
                function: _submitSignUp,
                text: authMode != AuthMode.Login ? "LOGIN" : "SIGN UP",
              ),
              const SizedBox(
                height: 15,
              ),
              defaultButton(  
                context: context,
                function: () {
                  _switchAuthMode;
                  Navigator.pop(context);
                },
                text: authMode == AuthMode.Login ? "LOGIN" : "SIGN UP",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
