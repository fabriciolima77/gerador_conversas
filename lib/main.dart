import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    title: "WhatsLink",
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController msgController = TextEditingController();
  TextEditingController url = TextEditingController();
  TextEditingController copiarLink = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  void _resetField() {
    msgController.text = "";
    _url = "";
    _numero = "";
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
  String _url = " ";

  void _iniciaConversa() async {
    String msgSemEspaco = msgController.text.replaceAll(" ", "%20");
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
  void _link() async{
    String msgSemEspaco = msgController.text.replaceAll(" ", "%20");
    String numero = _numero;
    String link = 'https://wa.me/';

    if (msgSemEspaco.isEmpty) {
      link = 'https://wa.me/$numero';
    } else {
      link = 'https://wa.me/$numero?text=$msgSemEspaco';
    }
    setState(() {
      _url = link;
    });
    print(_url);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Image.asset('assets/images/logo.png',
            fit: BoxFit.contain,
            width: 256),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(onPressed: _resetField, icon: Icon(Icons.refresh))
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        //formulario
        child: Container(
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wpp.png"),
              fit: BoxFit.contain,
              repeat: ImageRepeat.repeat,
            ),
          ),
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
                      hintStyle: TextStyle(color: Colors.grey[600]),
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
                  /*alignment: Alignment.center,*/
                  width: 400,
                  /*height: 150,*/
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Mensagem: ',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      hintStyle: TextStyle(color: Colors.grey[600]),
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
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    controller: msgController,
                  ),
                ),
                //botão enviar
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 80,
                  child: ElevatedButton(
                    child: Text('INICIAR CONVERSA'),
                    onPressed: _iniciaConversa,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent[400],
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 60,
                  child: ElevatedButton(
                    child: Text('GERAR LINK'),
                    onPressed: _link,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent[400],
                      padding: EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                      textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText(_url,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        showCursor: false,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false
                        ),
                      ),
                      /*ElevatedButton(
                        onPressed: (){
                        final data = ClipboardData(text: copiarLink.text);
                        Clipboard.setData(data);
                      },child: Icon(Icons.copy),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.greenAccent[400]))*/]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
