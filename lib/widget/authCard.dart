import 'package:ecomapp/model/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

enum AuthMode { login, signup }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _hightAnimation;
  late Animation<double> _opacity;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _hightAnimation = Tween<Size>(
            begin: const Size(double.maxFinite, 260),
            end: const Size(double.maxFinite, 320))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _opacity = Tween<double>(
            begin: 0.0,
            end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _hightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okey'))
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      var errorMessage = "Could not authanticate you. Please try again later";
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedBuilder(
        animation: _hightAnimation,
        builder: (context, ch) => Container(
          // height: _authMode == AuthMode.signup ? 320 : 260,
          height: _hightAnimation.value.height,
          constraints: BoxConstraints(
              // minHeight: _authMode == AuthMode.signup ? 320 : 260
              minHeight: _hightAnimation.value.height),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0), child: ch,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                
                  SlideTransition(
                    position: _slideAnimation,
                    child: AnimatedContainer(
                      constraints: BoxConstraints(minHeight: _authMode == AuthMode.signup ? 60 : 0, maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opacity,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.signup,
                          decoration:
                              const InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          // textStyle: const TextStyle(color: Colors.black),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                        ),
                        child: Text(
                          _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
