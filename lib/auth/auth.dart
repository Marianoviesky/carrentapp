import 'package:carrentapp/auth/authentication_service.dart';
import 'package:carrentapp/widgets/build_snack_error.dart';
import 'package:carrentapp/widgets/button_widget.dart';
import 'package:carrentapp/widgets/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool checkedValue = false;
  bool register = true;
  List textfieldsStrings = [
    "", //name
    "", //email
    "", //password
    "", //confirmPassword
  ];

  final _firstnamekey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: isDarkMode
              ? const Color(0xff06090d)
              : const Color(0xfff8f8f8), //appbar bg color
          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xff070606)
                      : Colors.white, //icon bg color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
               
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: Image.asset(
            isDarkMode
                ? 'assets/icons/first.png'
                : 'assets/icons/second.png', //logo
            height: size.height * 0.06,
            width: size.width * 0.35,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.05,
              ),
              child: SizedBox(
                height: size.width * 0.1,
                width: size.width * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff070606)
                        : Colors.white, //icon bg color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff0d141c) : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025,
                          vertical: size.height * 0.01,
                        ),
                      ),
                     
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.015),
                        child: Align(
                          child: register
                              ? Text(
                                  'Créer un compte',
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xff1D1617),
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Content de vous revoir 😊',
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xff1D1617),
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.01),
                      ),
                      register
                          ? buildTextField(
                              "Nom",
                              Icons.person_outlined,
                              false,
                              size,
                              (valuename) {
                                if (valuename.length <= 2) {
                                  buildSnackError(
                                    'Nom invalide',
                                    context,
                                    size,
                                  );
                                  return '';
                                }
                                return null;
                              },
                              _firstnamekey,
                              0,
                              isDarkMode,
                            )
                          : Container(),
                      Form(
                        child: buildTextField(
                          "Email",
                          Icons.email_outlined,
                          false,
                          size,
                          (valuemail) {
                            if (valuemail.length < 5) {
                              buildSnackError(
                                'Email invalide',
                                context,
                                size,
                              );
                              return '';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                .hasMatch(valuemail)) {
                              buildSnackError(
                                'Email invalide',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _emailKey,
                          1,
                          isDarkMode,
                        ),
                      ),
                      Form(
                        child: buildTextField(
                          "Mot de passe",
                          Icons.lock_outline,
                          true,
                          size,
                          (valuepassword) {
                            if (valuepassword.length < 6) {
                              buildSnackError(
                                'Mot de passe invalide',
                                context,
                                size,
                              );
                              return '';
                            }
                            return null;
                          },
                          _passwordKey,
                          2,
                          isDarkMode,
                        ),
                      ),
                      Form(
                        child: register
                            ? buildTextField(
                                "Confirmer Mot de passe",
                                Icons.lock_outline,
                                true,
                                size,
                                (valuepassword) {
                                  if (valuepassword != textfieldsStrings[2]) {
                                    buildSnackError(
                                      'Les mots de passes doivent ètre conformes',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                _confirmPasswordKey,
                                3,
                                isDarkMode,
                              )
                            : Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.025,
                        ),
                        child: register
                            ? CheckboxListTile(
                                title: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "En créant un compte, vous acceptez nos ",
                                        style: TextStyle(
                                          color: const Color(0xffADA4A5),
                                          fontSize: size.height * 0.015,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "Termes et conditions d'utilisation",
                                            style: TextStyle(
                                              color: const Color(0xffADA4A5),
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: size.height * 0.015,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                activeColor: const Color(0xff7B6F72),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Mot de passe oublié?",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    decoration: TextDecoration.underline,
                                    fontSize: size.height * 0.02,
                                  ),
                                ),
                              ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: register
                            ? EdgeInsets.only(top: size.height * 0.025)
                            : EdgeInsets.only(top: size.height * 0.085),
                        child: ButtonWidget(
                          cooldown: const Duration(seconds: 5),
                          text: register ? "S'inscrire" : "Se connecter",
                          height: size.height * 0.07,
                          width: size.width * 0.9,
                          borderRadius: 15,
                          backColors: isDarkMode
                              ? [
                                  Colors.black,
                                  Colors.black,
                                ]
                              : const [
                                  Color(0xff92A3FD),
                                  Color(0xff9DCEFF),
                                ],
                          textColors: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
                            if (register) {
                              if (_firstnamekey.currentState!.validate()) {
                                if (_emailKey.currentState!.validate()) {
                                  if (_passwordKey.currentState!.validate()) {
                                    if (_confirmPasswordKey.currentState!
                                        .validate()) {
                                      if (checkedValue == false) {
                                        buildSnackError(
                                            "Acceptez notre Politique et Termes d'utilisation ",
                                            context,
                                            size);
                                      } else {
                                        try {
                                          await authService
                                              .createUserWithEmailAndPassword(
                                            textfieldsStrings[1],
                                            textfieldsStrings[2],
                                            textfieldsStrings[0],
                                            context,
                                          );
                                        } on FirebaseAuthException catch (authEx) {
                                          if (authEx.code ==
                                              "insufficient-permission") {
                                            buildSnackError(
                                              "Vous n'avez pas toutes les permissions",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "email-already-in-use") {
                                            buildSnackError(
                                              "Cet email existe déjà",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "internal-error") {
                                            buildSnackError(
                                              "Erreur du serveur ,veuillez réessayer plus tard!",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "invalid-argument") {
                                            buildSnackError(
                                              "Mot de passe ou email invalide",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "invalid-credential") {
                                            buildSnackError(
                                              "Oups, une erreur s'est produite! (invalid-credential)",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "invalid-email") {
                                            buildSnackError(
                                              "Email invalide",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "invalid-password") {
                                            buildSnackError(
                                              "Mot de passe invalide",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "email-already-exists") {
                                            buildSnackError(
                                              "Cet email existe déjà",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "invalid-creation-time") {
                                            buildSnackError(
                                              "Time must be create in UTC system",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "invalid-uid") {
                                            buildSnackError(
                                              "Oups, une erreur s'est produite, veuillez réessayer",
                                              context,
                                              size,
                                            );
                                          } else if (authEx.code ==
                                              "uid-already-exists") {
                                            buildSnackError(
                                              "Oups, une erreur s'est produite, veuillez réessayer",
                                              context,
                                              size,
                                            );
                                          } else {
                                            buildSnackError(
                                              "Oups, une erreur s'est produite, veuillez vérifier votre connection",
                                              context,
                                              size,
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            } else {
                              if (_emailKey.currentState!.validate()) {
                                if (_passwordKey.currentState!.validate()) {
                                  try {
                                    await authService
                                        .signInWithEmailAndPassword(
                                      textfieldsStrings[1],
                                      textfieldsStrings[2],
                                    );
                                  } on FirebaseAuthException catch (authEx) {
                                    if (authEx.code == "user-not-found") {
                                      buildSnackError(
                                        "Ce compte n'existe pas",
                                        context,
                                        size,
                                      );
                                    } else if (authEx.code ==
                                        "insufficient-permission") {
                                      buildSnackError(
                                        "Vous ne disposez pas des permissions réquises",
                                        context,
                                        size,
                                      );
                                    } else if (authEx.code ==
                                        "internal-error") {
                                      buildSnackError(
                                        "Erreur du serveur, veuillez réessayer plus tard!",
                                        context,
                                        size,
                                      );
                                    } else if (authEx.code ==
                                        "invalid-argument") {
                                      buildSnackError(
                                        "Mot de passe ou email invalid",
                                        context,
                                        size,
                                      );
                                    } else if (authEx.code ==
                                        "invalid-credential") {
                                      buildSnackError(
                                        "Oups une erreur s'est produite! (invalid-credential)",
                                        context,
                                        size,
                                      );
                                    } else if (authEx.code == "invalid-email") {
                                      buildSnackError(
                                        "Email invalide",
                                        context,
                                        size,
                                      );
                                    } else if (authEx.code ==
                                        "invalid-password") {
                                      buildSnackError(
                                        "Mot de passe invalide",
                                        context,
                                        size,
                                      );
                                    } else {
                                      buildSnackError(
                                        "Oups une erreur s'est produite ,veuillez vérifier votre connection",
                                        context,
                                        size,
                                      );
                                    }
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(
                          top: register
                              ? size.height * 0.025
                              : size.height * 0.15,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: register
                                  ? "Vous avez déjà un compte? "
                                  : "Pas de compte? ",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff1D1617),
                                fontSize: size.height * 0.018,
                              ),
                            ),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () => setState(() {
                                  if (register) {
                                    register = false;
                                  } else {
                                    register = true;
                                  }
                                }),
                                child: register
                                    ? Text(
                                        "Se connecter",
                                        style: TextStyle(
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: <Color>[
                                                Color(0xffEEA4CE),
                                                Color(0xffC58BF2),
                                              ],
                                            ).createShader(
                                              const Rect.fromLTWH(
                                                0.0,
                                                0.0,
                                                200.0,
                                                70.0,
                                              ),
                                            ),
                                          fontSize: size.height * 0.018,
                                        ),
                                      )
                                    : Text(
                                        "S'inscrire",
                                        style: TextStyle(
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: <Color>[
                                                Color(0xffEEA4CE),
                                                Color(0xffC58BF2),
                                              ],
                                            ).createShader(
                                              const Rect.fromLTWH(
                                                  0.0, 0.0, 200.0, 70.0),
                                            ),
                                          // color: const Color(0xffC58BF2),
                                          fontSize: size.height * 0.018,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(
                          top: register
                              ? size.height * 0.005
                              : size.height * 0.01,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool pwVisible = false;
  Widget buildTextField(
    String hintText,
    IconData icon,
    bool password,
    size,
    FormFieldValidator validator,
    Key key,
    int stringToEdit,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.05,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Form(
          key: key,
          child: TextFormField(
            style: TextStyle(
                color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            onChanged: (value) {
              setState(() {
                textfieldsStrings[stringToEdit] = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.012,
              ),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
              suffixIcon: password
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.005,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pwVisible = !pwVisible;
                          });
                        },
                        child: pwVisible
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Color(0xff7B6F72),
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Color(0xff7B6F72),
                              ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
