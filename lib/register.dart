import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Register",
      home: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}