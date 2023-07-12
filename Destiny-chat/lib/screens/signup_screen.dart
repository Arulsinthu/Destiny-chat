import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Error signing up!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Okay',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/k.jpeg",
              ),
              scale: 0.2,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              alignment: Alignment(0.0, 0.0),
              height: 500,
              width: 600,
              color: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: LayoutBuilder(
                  builder: (ctx, viewportConstraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              AuthForm(false, _showErrorDialog),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
