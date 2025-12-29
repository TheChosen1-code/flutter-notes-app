import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/login.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User', style: TextStyle(fontSize: 35)),
        elevation: 10,
        toolbarHeight: 90,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(fit: StackFit.expand, children: [
        Lottie.asset(
          'assets/anim.json',
          fit: BoxFit.cover,
          repeat: true,
          animate: true,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                      height: 200,
                      child: Icon(
                        Icons.person_add,
                        size: 100,
                        color: Colors.white,
                      )),
                  Text(
                    'Register Yourself',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Input(
                    value: 'Email Address',
                    controller: emailController,
                    obscure: false,
                  ),
                  SizedBox(height: 16),
                  Input(
                    value: 'Password',
                    controller: passwordController,
                    obscure: true,
                    password: true,
                  ),
                  Row(
                    children: [
                      Text(
                        '\t Already a user ?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill all fields")),
                        );
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('The user is registered successfully'),
                          ),
                        );

                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);

                        // SUCCESS → AuthGate will handle navigation
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message ?? "Registration failed"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.amber.shade400,
                      elevation: 10,
                    ),
                    child: Text(
                      'Register Now',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class Input extends StatefulWidget {
  final String value;
  final bool obscure;
  final TextEditingController controller;
  final bool password;
  const Input({
    super.key,
    required this.value,
    required this.controller,
    this.obscure = false,
    this.password = false,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late bool _isObscured;
  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.value,
        suffixIcon: widget.password == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: _isObscured == true
                    ? Icon(Icons.remove_red_eye)
                    : Icon(Icons.visibility_off))
            : Icon(Icons.email),
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: const BorderSide(
            color: Colors.amber,
            width: 2,
          ),
        ),
      ),
    );
  }
}
