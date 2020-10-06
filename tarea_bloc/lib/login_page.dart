import 'package:flutter/material.dart';
import 'package:form_get_users_bloc/home/home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isTextHidden = true;
  TextEditingController _userTextController;
  TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // username tf
                TextFormField(
                  controller: _userTextController,
                  decoration: InputDecoration(
                    hintText: "Ingresar usuario",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (text) {
                    if (text.isEmpty)
                      return "favor de ingresar algo";
                    else
                      return null;
                  },
                ),
                // password tf
                TextFormField(
                  controller: _passwordTextController,
                  obscureText: _isTextHidden,
                  decoration: InputDecoration(
                    hintText: "Ingrsar password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isTextHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isTextHidden = !_isTextHidden;
                          });
                        }),
                  ),
                  validator: (text) {
                    if (text.isEmpty)
                      return "favor de ingresar password";
                    else
                      return null;
                  },
                ),
                SizedBox(height: 24),
                MaterialButton(
                  onPressed: _openHomePage,
                  child: Text("Ingresar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // validation method on pressed
  _openHomePage() {
    if (_formKey.currentState.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      return Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Falta completar formulario"),
          ),
        );
    }
  }
}
