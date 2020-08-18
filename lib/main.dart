import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomDrawer(),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  static CustomDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomDrawerState>();
  @override
  CustomDrawerState createState() => new CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  static const double maxSlide = 225;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void close() => _animationController.reverse();
  void open() => _animationController.forward();
  void toggleDrawer() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: AnimatedBuilder(
        animation: _animationController,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Appbar"),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => toggleDrawer(),
            ),
          ),
          body: Container(
            color: Colors.yellow,
          ),
        ),
        builder: (context, child) {
          double animValue = _animationController.value;
          final slideAmount = maxSlide * animValue;
          final contentScale = 1.0 - (0.3 * animValue);
          return Stack(
            children: <Widget>[
              MyDrawer(),
              Transform(
                transform: Matrix4.identity()
                  ..translate(slideAmount)
                  ..scale(contentScale, contentScale),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _animationController.isCompleted ? close : null,
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: Colors.red,
                width: 200,
              ),
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('News'),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Favourites'),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
