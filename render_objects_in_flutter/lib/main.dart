import 'package:flutter/material.dart';
import 'package:render_objects_in_flutter/custom_column.dart';
import 'package:render_objects_in_flutter/custom_expanded.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Foo());
  }
}

class Foo extends StatefulWidget {
  const Foo({super.key});

  @override
  State<Foo> createState() => _FooState();
}

class _FooState extends State<Foo> {
  @override
  Widget build(BuildContext context) {
    return  CustomColumn(
      children: [
        CustomExpanded(
          child: const SizedBox()),
        const Padding(
          padding:EdgeInsets.all(16),
          // ignore: unnecessary_const
          child: const Text(
            'A definitive guide to \n RenderObjects in Flutter',
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
              'by ibkisthere',
              textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
