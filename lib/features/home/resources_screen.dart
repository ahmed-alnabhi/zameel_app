// 
import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Container(
        height: 300 ,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        width: double.infinity,
       ),
    );
  }
}