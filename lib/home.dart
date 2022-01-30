import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController msgController = TextEditingController();
  TextEditingController url = TextEditingController();
  TextEditingController copiarLink = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String phoneNumber;
  String phoneIsoCode;
  String _numero;
  String _url = " ";
  String link = 'https://wa.me/';
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    var larguraResponsiva = larguraTela < 800 ?
    larguraTela * 0.8 :
    larguraTela < 1024 ?
    larguraTela * 0.5 : larguraTela * 0.4;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Image.asset('assets/images/logo.png',
              fit: BoxFit.contain, width: 256),
        ),
        backgroundColor: Colors.greenAccent[400],
        elevation: 0,
        actions: <Widget>[
          IconButton(onPressed: _resetField, icon: Icon(Icons.refresh))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
      ),
      /*backgroundColor: Colors.grey[300],*/
      body: Center(
        //formulario
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: larguraResponsiva,
                  height: 100,
                  child: IntlPhoneField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Número com DDD: ',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.white54,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent[400]),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
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
                  width: larguraResponsiva,
                  height: alturaTela * 0.2,
                  child: buildTextField(
                      "Mensagem: ", msgController, TextInputType.multiline),
                ),
                SizedBox(height: 10.0),
                //botão enviar
                Container(
                    alignment: Alignment.center,
                    width: 400,
                    child: buildElevatedButton(
                        "INICIAR CONVERSA", _iniciaConversa, 30, 20)
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  child: buildElevatedButton("GERAR LINK", _link, 55, 20),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Visibility(
                    visible: _isVisible,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectableText(
                            _url,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            showCursor: false,
                            enableInteractiveSelection: true,
                            toolbarOptions: ToolbarOptions(
                                copy: true,
                                selectAll: true,
                                cut: false,
                                paste: false),
                          ),
                          ElevatedButton(
                              onPressed: (){
                                Clipboard.setData(new ClipboardData(text: _url));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    new SnackBar(content: new Text("Link copiado para Área de Transferência"),
                                    ));
                              },
                              child: Icon(Icons.copy),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.greenAccent[400]))
                        ]),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _resetField() {
    msgController.text = "";
    _url = "";
    _numero = "";
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  void _iniciaConversa() async {

    if (msgController.text.isEmpty) {
      _url = 'https://wa.me/$_numero';
    } else {
      _url = 'https://wa.me/$_numero?text=${msgController.text.replaceAll(" ", "%20")}';
    }

    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Não foi possivel iniciar $_url';
    }
  }

  void _link() async {

    if (msgController.text.isEmpty) {
      link = 'https://wa.me/$_numero';
    } else {
      link = 'https://wa.me/$_numero?text=${msgController.text.replaceAll(" ", "%20")}';
    }
    setState(() {
      _url = link;
      _isVisible = true;
    });
  }

}

Widget buildTextField(String text, TextEditingController c, keyboard) {
  return TextField(
    keyboardType: keyboard,
    maxLines: null,
    decoration: InputDecoration(
      hintText: text,
      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white54,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.greenAccent[400]),
      ),
    ),
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.black, fontSize: 15.0),
    controller: c,
  );
}

Widget buildElevatedButton(String text, Function f, double h, double v) {
  return ElevatedButton(
    onPressed: f,
    child: Text("$text"),
    style: ElevatedButton.styleFrom(
      primary: Colors.greenAccent[400],
      padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.greenAccent[400])),
    ),
  );
}