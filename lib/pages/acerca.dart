import 'package:flutter/material.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 50,
        title: const Text(
          'AppBar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Text(
                "Integrantes",
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Text(
                "José Rojas",
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
