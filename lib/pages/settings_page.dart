import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toody/pages/auth_page.dart';

import 'package:toody/pages/login_page.dart';

//Da risolvere bug checkbox
class settings_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Row(
        children: [
          TextButton(
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.yellow),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => auth_page()));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
