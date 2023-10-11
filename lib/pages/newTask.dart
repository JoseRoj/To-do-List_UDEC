import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:udec_ev1/pages/principal.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';

final today = DateUtils.dateOnly(DateTime.now());
const List<Widget> options = <Widget>[
  Text('Codear'),
  Text('Comer'),
  Text('Flojear'),
  Text('Comprar'),
];

class Task extends StatefulWidget {
  //final String title;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(2021, 8, 10),
    //DateTime(2021, 8, 13),
  ];
  final List<bool> _selectedOptions = <bool>[false, true, false, false];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKeyname = GlobalKey<FormState>();
  final _formKeydescription = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadCards();
  }

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
    final double sizeForms = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons
              .arrow_back), // Icono personalizado en lugar de la flecha de retroceso
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => principal()),
            );
            //saveCards();
            //loadCards();
          },
        ),

        // Lógica personalizada al presionar el botón de inicio

        backgroundColor: Theme.of(context).primaryColorDark,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 50,
        title: const Text(
          'App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.71,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          //width: MediaQuery.of(context).size.height * 0.85,

                          child: _buildCalendarDialogButton(),
                        ),
                        buildForm(
                          exText: "Ejemplo: José Rojas",
                          title: "Nombre",
                          minLines: 1,
                          maxLines: 1,
                          size: sizeForms,
                          controller: _nameController,
                          formKey: _formKeyname,
                          obscure: false,
                        ),
                        buildForm(
                          exText: "Opcional",
                          title: "Descripción",
                          minLines: 2,
                          maxLines: 3,
                          size: sizeForms,
                          controller: _descriptionController,
                          formKey: _formKeydescription,
                          obscure: false,
                        ),
                        /*_buildForms("Descripción", "Opcional", 2, 3,
                            _descriptionController),*/
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              _buildToggleButtom(
                                  0,
                                  [_selectedOptions[0], _selectedOptions[1]],
                                  [Colors.orange, Colors.green],
                                  ["Codear", "Flojear"]),
                              const SizedBox(
                                height: 5,
                              ),
                              _buildToggleButtom(
                                  2,
                                  [_selectedOptions[2], _selectedOptions[3]],
                                  [Colors.blue, Colors.grey],
                                  ["Comer", "Comprar"])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 70,
                    right: MediaQuery.of(context).size.width * 0.9 / 2 -
                        MediaQuery.of(context).size.width * 0.5 / 2,

                    //100, //widthFactor: 0.8,*/
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_formKeyname.currentState!.validate()) {
                            if (_dialogCalendarPickerValue.length == 2) {
                              listCards.add(
                                CardTodo(
                                    _nameController.text,
                                    _descriptionController.text,
                                    _dialogCalendarPickerValue[0],
                                    _dialogCalendarPickerValue[1],
                                    _selectedOptions),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tarea ingresada con exito'),
                                ),
                              );

                              saveCards();
                              //loadCards();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Asegurate que los campos de fecha esten llenos'),
                              ),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 38, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Guardar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType, List<DateTime?> values) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  Widget _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Theme.of(context).primaryColor,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              //margin: EdgeInsets.only(right: 20, left: 20),
              child: ElevatedButton(
                onPressed: () async {
                  final values = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: config,
                    dialogSize: const Size(325, 400),
                    //borderRadius: BorderRadius.circular(15),
                    value: _dialogCalendarPickerValue,
                    dialogBackgroundColor: Colors.white,
                  );

                  if (values != null) {
                    // ignore: avoid_print
                    print(_getValueText(
                      config.calendarType,
                      values,
                    ));
                    setState(() {
                      if (values.length == 2) {
                        _dialogCalendarPickerValue = values;
                      } else {
                        _dialogCalendarPickerValue[0] = values[0];
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  //fixedSize: Size(10, 20),
                  //maximumSize: const Size(45, 350),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          //padding: const EdgeInsets.all(15),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Fecha Inicio", style: TextStyle(fontSize: 16)),
                _buildContainerFechas(
                  _dialogCalendarPickerValue[0]
                      .toString()
                      .replaceAll('00:00:00.000', ''),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Fecha Fin", style: TextStyle(fontSize: 16)),
                _dialogCalendarPickerValue.length >= 2
                    ? _buildContainerFechas(
                        _dialogCalendarPickerValue[1]
                            .toString()
                            .replaceAll('00:00:00.000', ''),
                      )
                    : _buildContainerFechas(""),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContainerFechas(String d1) {
    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width * 0.4,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(
          d1, //.toString().replaceAll('00:00:00.000', ''),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  /*Widget _buildForms(
    String title,
    String exText,
    int minLines,
    int maxLines,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, color: Colors.black)),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            //key: _formKey,
            child: TextFormField(
              minLines: minLines,
              maxLines: maxLines,
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                labelText: exText,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa un valor';
                }
              },
            ),
          ),
        ),
      ],
    );
  }
*/
  Widget _buildToggleButtom(
    int num,
    List<bool> options,
    List<Color> colour,
    List<String> action,
  ) {
    return ToggleButtons(
      onPressed: (int index) {
        // All buttons are selectable.
        setState(() {
          _selectedOptions[index + num] = !_selectedOptions[index + num];
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      //selectedBorderColor: Colors.black,
      selectedColor: Colors.red,
      fillColor: Colors.yellow,
      isSelected: [options[0], options[1]],
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 20, left: 20),
          width: 100,
          height: 50,
          color: colour[0], // Color para el botón 1
          child: Center(
              child:
                  Text(action[0], style: const TextStyle(color: Colors.white))),
        ),
        Container(
          margin: const EdgeInsets.only(right: 20, left: 20),
          color: colour[1], // Color para el botón 2
          width: 100,
          height: 50,
          child: Center(
              child:
                  Text(action[1], style: const TextStyle(color: Colors.white))),
        ),
      ],
    );
  }
}

class buildForm extends StatelessWidget {
  final String exText, title;
  final int minLines, maxLines;
  final double size;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final bool obscure;
  const buildForm(
      {required this.exText,
      required this.title,
      required this.minLines,
      required this.maxLines,
      required this.size,
      required this.controller,
      required this.formKey,
      required this.obscure});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, color: Colors.black)),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: size,
          child: Form(
            key: formKey,
            child: TextFormField(
              obscureText: obscure,
              minLines: minLines,
              maxLines: maxLines,
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 5.0,
                ),
                labelText: exText,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa un valor';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
