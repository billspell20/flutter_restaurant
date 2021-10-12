import 'package:flutter/material.dart';

class MessageSnack {
  void showInfoMessage(_scaffoldKey, isLogin, [void Function()? _onClose]) {
    _showMessage(false, isLogin, _scaffoldKey, _onClose!);
  }

  void showErrorMessage(isLogin, _scaffoldKey, [void Function()? _onClose]) {
    _showMessage(true, isLogin, _scaffoldKey, _onClose!);
  }

  void _showMessage(_isError, isLogin, _scaffoldKey,
      [void Function()? _onClose]) {
    // if one is open, close it
    _scaffoldKey.currentState
        .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
    var errorString = "Error with credentials. Please try again.";
    if (isLogin) {
      errorString =
          "Error logging in - incorrect email or password. Please double check your credentials.";
    } else {
      errorString =
          "Error registering user. Please make sure email is correctly formatted (ie. 'user@user.com') and/or password is at least 6 characters.";
    }

    SnackBar snackBar = SnackBar(
      key: new Key('error_Snackbar'),
      content: Text(errorString, key: new Key('error_message')),
      duration: Duration(seconds: 5),
      backgroundColor: _isError ? Colors.redAccent : Colors.grey,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change!
          _scaffoldKey.currentState
              .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
        },
      ),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((reason) {
      // snackbar is now closed, close window
      if (_onClose != null) _onClose();
    });
  }
}
