import 'package:flutter/material.dart';
import 'package:udec_ev1/pages/newTask.dart';
import 'package:shared_preferences/shared_preferences.dart';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reppasswordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  String nombre = "";
  String email = "";
  String contrasena = "";
  final _formKeymail = GlobalKey<FormState>();
  final _formKeyname = GlobalKey<FormState>();
  final _formKeypassword = GlobalKey<FormState>();
  final _formRepKeypassword = GlobalKey<FormState>();

  //String password = "";
  //String mail = "";
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  void initState() {
    super.initState();
    _loadPreferences();
  }

  //String nombre = "José Rojas";
  //String password = "Jose";
  //String correo = "joserojas@udec.cl";

  Future<void> _loadPreferences() async {
    final SharedPreferences pref = await _pref;
    String name = pref.getString('name') ?? '';
    String password = pref.getString('password') ?? '';
    String mail = pref.getString('mail') ?? '';
    setState(
      () {
        nombre = name;
        email = mail;
        contrasena = password;
      },
    );
  }

  Future<void> _savePreferences() async {
    final SharedPreferences pref = await _pref;
    await pref.setString('name', _nameController.text);
    await pref.setString('password', _passwordController.text);
    await pref.setString('mail', _mailController.text);
  }

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
                /*Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.7,
                    color: Theme.of(context).primaryColor),*/
                Container(
                  padding: const EdgeInsets.only(left: 25, top: 20),
                  height: MediaQuery.of(context).size.height * 0.51,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildForm(
                        exText: "ej: jorojas2019@udec.cl",
                        title: "Login",
                        minLines: 1,
                        maxLines: 2,
                        size: sizeForms,
                        controller: _mailController,
                        formKey: _formKeymail,
                        obscure: false,
                      ),
                      buildForm(
                        exText: "'Ingresa tu clave'",
                        title: "Password",
                        minLines: 1,
                        maxLines: 1,
                        size: sizeForms,
                        controller: _passwordController,
                        formKey: _formKeypassword,
                        obscure: true,
                      ),
                      buildForm(
                        exText: "Reingresa tu clase",
                        title: "Repetir Clave",
                        minLines: 1,
                        maxLines: 1,
                        size: sizeForms,
                        controller: _reppasswordController,
                        formKey: _formRepKeypassword,
                        obscure: true,
                      ),
                      buildForm(
                        exText: "ej: José Rojas",
                        title: "Nombre",
                        minLines: 1,
                        maxLines: 2,
                        size: sizeForms,
                        controller: _nameController,
                        formKey: _formKeyname,
                        obscure: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 30), // Espacio en la parte inferior
            child: ElevatedButton(
              onPressed: () {
                if (_formKeyname.currentState!.validate() &&
                    _formKeymail.currentState!.validate() &&
                    _formKeypassword.currentState!.validate()) {
                  if (_reppasswordController.text == _passwordController.text) {
                    _savePreferences();
                    _loadPreferences();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preferencias guardadas con éxito'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contraseñas diferentes'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.7,
                  MediaQuery.of(context).size.height * 0.04,
                ),
                backgroundColor: const Color.fromARGB(255, 4, 38, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child:
                  const Text("Guardar", style: TextStyle(color: Colors.white)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.7,
                MediaQuery.of(context).size.height * 0.04,
              ),
              backgroundColor: const Color.fromARGB(255, 4, 38, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Volver", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
