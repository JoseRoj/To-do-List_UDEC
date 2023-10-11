import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udec_ev1/main.dart';
import 'package:udec_ev1/pages/acerca.dart';
import 'package:udec_ev1/pages/newTask.dart';

List<CardTodo> listCards = [
  /* Card("hola", "dsfgdg", DateTime.now(), DateTime.now()),
    Card("hola", "dsfgdg", DateTime.now(), DateTime.now()),
    Card("hola", "dsfgdg", DateTime.now(), DateTime.now())*/
];

class CardTodo {
  String nombre;
  String description;
  DateTime? Finit;
  DateTime? Fend;
  List<dynamic> action;
  CardTodo(this.nombre, this.description, this.Finit, this.Fend, this.action);

  //* Convertir objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'description': description,
      'Fnit': Finit,
      'Fend': Fend,
      'action': action,
    };
  }

  //* Crear un objeto desde un mapa
  factory CardTodo.fromMap(Map<String, dynamic> map) {
    return CardTodo(
      map['nombre'],
      map['description'],
      DateTime.parse(map['Fnit']),
      DateTime.parse(map['Fend']),
      map['action'],
    );
  }
}

class principal extends StatefulWidget {
  @override
  State<principal> createState() => _principalState();
}

class _principalState extends State<principal> {
  final List<Color> colores = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.grey
  ];
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future<void> loadCards() async {
    final SharedPreferences pref = await _pref;
    final cards = pref.getString('Cards');

    if (cards != null) {
      final List<dynamic> parsedList = jsonDecode(cards);
      setState(() {
        listCards = parsedList.map((e) => CardTodo.fromMap(e)).toList();
      });
    }
  }

  /*Future<void> _removeValue() async {
    // Utiliza el método remove para eliminar un elemento específico por su clave.
    final SharedPreferences pref = await _pref;
    await pref.remove('Cards');
  }*/

  Future<void> _removeAllCards() async {
    final SharedPreferences pref = await _pref;
    listCards.removeRange(0, listCards.length);
    pref.remove('Cards');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  //* Convertir objeto en un formato valido
  Future<void> saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cards = listCards.map((e) => e.toMap()).toList();
    for (var card in cards) {
      card['Fnit'] = card['Fnit'].toIso8601String();
      card['Fend'] = card['Fend'].toIso8601String();
    }
    final cardsJson = jsonEncode(cards);
    await prefs.setString('Cards', cardsJson);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCircularButton(Color colour) {
      return Container(
        margin: EdgeInsets.only(left: 4, right: 4),
        width: 25.0, // Puedes ajustar el tamaño según tus necesidades
        height: 25.0, // Puedes ajustar el tamaño según tus necesidades
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Esto hace que el contenedor sea circular
          border: Border.all(
            color: Colors.black,
          ),
          color: colour, // Color de fondo del botón
        ),
      );
    }

    Widget _buildCard(
      String name,
      String description,
      String fInit,
      String fFinal,
      VoidCallback functDelete,
      List<dynamic> colors,
    ) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        //width: MediaQuery.of(context).size.width * 0.80, //0.6,
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        padding: EdgeInsets.all(8),
        color: Colors.green,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: Text(description, style: TextStyle(fontSize: 15)),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.34,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: colors.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final bool elemento = entry.value;
                      if (elemento == true) {
                        return _buildCircularButton(colores[index]);
                      }
                      return Container(
                        width: 0,
                        height: 0,
                      );
                      //return _buildCircularButton(Colors.black);
                    }).toList(),
                    /*Expanded(
              child: ListView.builder(
                //shrinkWrap:
                //   true, // Esto evita que el ListView ocupe todo el espacio vertical disponible
                scrollDirection:
                    Axis.horizontal, // Configura la dirección horizontal
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  return _buildCircularButton(colors[index]);
                },
              ),
            ),*/

                    /*_buildCircularButton(Colors.orange),
                      _buildCircularButton(
                          const Color.fromARGB(255, 122, 237, 126)),
                      _buildCircularButton(Colors.blue),
                      _buildCircularButton(Colors.grey),*/
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    fInit + " - " + fFinal,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.12,
                      //height: MediaQuery.of(context).size.height * 0.04,
                      child: ElevatedButton(
                        onPressed: functDelete,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                        child: Icon(
                          Icons.close,
                          size: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.white,
                        ), //Icon(Icons.one_x_mobiledata),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
          //),
        ),
      );
    }

    Widget _buildBottomDrawer(VoidCallback funct, String txt) {
      return Container(
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: funct,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
          child: Text(txt),
        ),
      );
    }

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

      body: ListView.builder(
        //reverse: false,
        itemCount: listCards.length,
        itemBuilder: (context, index) {
          return _buildCard(
              listCards[index].nombre,
              listCards[index].description,
              listCards[index].Finit.toString().replaceAll('00:00:00.000', ''),
              listCards[index].Fend.toString().replaceAll('00:00:00.000', ''),
              () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Esta seguro de eliminar esta "Tarea'),
                  content:
                      const Text('Se eliminará para siempre de su To do List'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context),
                        setState(() {
                          saveCards();
                          //loadCards();
                          listCards.removeAt(index);
                        }),
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              },
            );
          }, listCards[index].action);
        },
        /*children: [
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
          _buildCard("nombre", "Descripcion", "10-03-2020", "20-10-2021", () {},
              () {}, () {}, () {}, () {}),
        ],*/
      ),
      //  ),
      //],
      //),
      drawer: Container(
        margin: const EdgeInsets.only(top: 110),
        width: MediaQuery.of(context).size.width * 0.6, // Ancho personalizado
        color: Theme.of(context).primaryColor, // Color personalizado
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.15,
              color: Theme.of(context).primaryColorDark,
              child: const Center(
                child: Text(
                  "Mi name",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            _buildBottomDrawer(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Task(),
                ),
              );

              /*setState(() {
                saveCards();
                listCards.add(
                    Card("hola", "dsfgdg", DateTime.now(), DateTime.now()));
              });*/
            }, "Nueva Tarea"),
            _buildBottomDrawer(() {
              _removeAllCards();
              setState(() {});
              // Utiliza el método remove para eliminar un elemento específico por su clave.
            }, "Borrar Todo"),
            _buildBottomDrawer(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => about(),
                ),
              );
            }, "Acerca de"),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomDrawer(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }, "Salir"),
              ),
            )
          ],
          //lateral(),
        ),
      ),
    );
  }
}
