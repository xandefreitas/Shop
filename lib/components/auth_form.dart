import 'package:flutter/material.dart';
import 'package:flutter_shop/exceptions/auth_exception.dart';
import 'package:flutter_shop/model/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { SIGNUP, LOGIN }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.LOGIN;
  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _heightAnimation = Tween(
      begin: Size(double.infinity, 310),
      end: Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );
    _heightAnimation?.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(16),
        height: _heightAnimation?.value.height ?? (_isLogin ? 310 : 400),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isSignup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas informadas não conferem';
                          }
                          return null;
                        },
                ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'ENTRAR' : 'REGISTRAR'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8)),
                    ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_isLogin ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_isLogin) {
        await auth.signIn(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await auth.signUp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (e) {
      _showErrorDialog(e.toString());
    } catch (e) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  _switchAuthMode() {
    setState(() {
      if (_isLogin) {
        _authMode = AuthMode.SIGNUP;
        _controller?.forward();
      } else {
        _authMode = AuthMode.LOGIN;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Fechar')),
        ],
      ),
    );
  }

  bool get _isLogin => _authMode == AuthMode.LOGIN;
  bool get _isSignup => !_isLogin;
}
