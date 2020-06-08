import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAddingDataDialog {
  static bool isItShowing = false;
  static final inputControler = TextEditingController();
  static Future showMyDialog(BuildContext context, String lable,
      Future onPress(String value), Function() afterFinishing) async {
    isItShowing = true;
    bool isLoading = false;
    GlobalKey<FormState> myKey = GlobalKey<FormState>();
    await showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) => StatefulBuilder(
            builder: (context, stater) => SimpleDialog(
                  elevation: 5,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: myKey,
                          child: TextFormField(
                            enabled: !isLoading,
                            controller: inputControler,
                            maxLines: 20,
                            maxLength: 100,
                            minLines: null,
                            validator: (value) {
                              try {
                                json.decode(value);
                                return null;
                              } catch (e) {
                                return "Not valide JSON format";
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                labelText: lable),
                          )),
                    ),
                    CupertinoButton(
                        child: !isLoading
                            ? Text("Submit")
                            : CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: CircularProgressIndicator(),
                              ),
                        onPressed: () async {
                          if (myKey.currentState.validate()) {
                            stater(() {
                              isLoading = true;
                            });
                            await onPress(inputControler.text);
                            stater(() {
                              isLoading = false;
                            });

                            if (isItShowing) Navigator.pop(context);
                            afterFinishing();
                          }
                        })
                  ],
                )));
    isItShowing = false;
  }
}
