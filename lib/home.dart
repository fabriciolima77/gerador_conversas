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
  String link;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    var larguraResponsiva = larguraTela < 800 ?
    larguraTela * 0.9 :
    larguraTela < 1024 ?
    larguraTela * 0.5 : larguraTela * 0.4;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Image.asset('assets/images/logo.png',
              fit: BoxFit.contain, width: 256),
        ),
        backgroundColor: Color(0xFF25D366),
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
                SizedBox(height: 20.0),
                Container(
                  width: larguraTela * 0.5,
                  child: Visibility(
                    visible: _isVisible,
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 20,
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
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF25D366)),
                              onPressed: (){
                                Clipboard.setData(new ClipboardData(text: _url));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    buildSnackBar(width: larguraTela * 0.3));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Copiar Link"),
                                  SizedBox(width: 10),
                                  Icon(Icons.copy),
                                ],
                              ),
                          ),
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
      _isVisible = false;
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
      _url = 'https://api.whatsapp.com/send/?phone=${Uri.encodeFull(_numero)}&app_absent=0';
    } else {
      _url =
      'https://api.whatsapp.com/send/?phone=${Uri.encodeFull(_numero)}&text=${Uri.encodeFull(msgController.text)}&app_absent=0';
    }

    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Não foi possivel iniciar $_url';
    }
  }

  void _link() async {

    if (msgController.text.isEmpty) {
      link = 'https://api.whatsapp.com/send/?phone=${Uri.encodeFull(_numero)}&app_absent=0';
    } else {
      link = 'https://api.whatsapp.com/send/?phone=${Uri.encodeFull(_numero)}&text=${Uri.encodeFull(msgController.text)}&app_absent=0';
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
      primary:  Color(0xFF25D366),
      padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color:  Color(0xFF25D366))),
    ),
  );
}

Widget buildSnackBar({double width}){
  return SnackBar(
      content: Text(
        "Link copiado para a Área de Transferência.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F644D),
        ),
      ),
    duration: const Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    width: width,
    backgroundColor: Colors.white,
    shape: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0F644D)),
      borderRadius: BorderRadius.circular(10.0)
    )
  );
}