import 'package:flutter/material.dart';

class lateral extends StatelessWidget {
  const lateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      child: Container(
        color: Colors.amber,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                child: Text("name"),
              ),
            ),
            Container(
              child: Text("Nueva"),
            )
            /*ListTile(
              title: const Text("Inicio"),
              onTap: () {
                //print("Inicio");
              },
            ),
            ListTile(
              title: const Text("Home"),
              onTap: () {
                //print("Home");
              },
            ),
            ListTile(
              title: const Text("opcion 3"),
              onTap: () {
                //print("Opcion 3");
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
