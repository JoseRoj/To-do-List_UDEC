import 'package:flutter/material.dart';
import 'package:udec_ev1/pages/newTask.dart';
import 'package:udec_ev1/pages/principal.dart';
import 'package:udec_ev1/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 49, 110, 201),
        primaryColorDark: const Color.fromARGB(255, 0, 43, 128),
        cardColor: const Color.fromARGB(255, 68, 159, 58),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKeyLogin = GlobalKey<FormState>();
  final formKeypassword = GlobalKey<FormState>();
  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double sizeForms = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        //title: Text(widget.title),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 0),
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width * 0.5, //0.6,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/images/udec.jpg',
              ),
            ),
          ),
          Center(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Theme.of(context).primaryColor,
                  /*decoration: BoxDecoration(
                    //color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  )*/
                ),
                Container(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  height: MediaQuery.of(context).size.height * 0.41,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildForm(
                        exText: 'Ej: jorojas@udec.cl',
                        title: "Login",
                        minLines: 1,
                        maxLines: 1,
                        size: sizeForms,
                        controller: controllerLogin,
                        formKey: formKeyLogin,
                        obscure: false,
                      ),
                      buildForm(
                        exText: "",
                        title: "Password",
                        minLines: 1,
                        maxLines: 1,
                        size: sizeForms,
                        controller: controllerPassword,
                        formKey: formKeypassword,
                        obscure: true,
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  right: MediaQuery.of(context).size.width * 0.7 / 2 -
                      MediaQuery.of(context).size.width * 0.5 / 2,

                  //100, //widthFactor: 0.8,*/
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKeyLogin.currentState!.validate() &&
                          formKeypassword.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => principal()),
                        );
                      }
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 4, 38, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Acceder',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 80), // Espacio en la parte inferior
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => register()),
                );
              },
              child: const Text("Registrar usuario",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
