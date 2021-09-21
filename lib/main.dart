import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController numberController = TextEditingController();
  TextEditingController msgController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  void _resetField() {
    numberController.text = "";
    msgController.text = "";
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }
  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber,
      String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  String _numero;

  void _geraLink() async {
    String msg = msgController.text;
    String msgSemEspaco = msg.replaceAll(" ", "%20");
    String numero = _numero;
    String url = 'https://wa.me/';
    if (msgSemEspaco.isEmpty) {
      url = 'https://wa.me/$numero';
    } else {
      url = 'https://wa.me/$numero?text=$msgSemEspaco';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possivel iniciar $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GeradorDeMensagens"),
        leading: IconButton(
          icon: Image.asset('assets/images/wpp_logo.png'),
          onPressed: () {},
        ),
        backgroundColor: Colors.teal[300],
        actions: <Widget>[
          IconButton(onPressed: _resetField, icon: Icon(Icons.refresh))
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wpp.png"),
            fit: BoxFit.cover,
            elevation: 0,
          ),
        ),*/
        //formulario
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30),
                alignment: Alignment.centerLeft,
                width: 400,
                height: 100,
                child: IntlPhoneField(
                    keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
                    hintText: 'Número com DDD: ',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                  initialCountryCode: 'BR',
                  onChanged: (phone) {
                    setState(() {
                      _numero = phone.completeNumber;
                    });
                  },
                ),
              ),
              //formulario mensagem
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 100,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Mensagem: ',
                    contentPadding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                  controller: msgController,
                ),
              ),
              //botão enviar
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 100,
                child: ElevatedButton(
                  child: Text('INICIAR CONVERSA'),
                  onPressed: _geraLink,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    textStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
