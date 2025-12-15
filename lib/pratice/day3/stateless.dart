import 'package:flutter/material.dart';

// StatelessWidget: No internal state, rebuilds only when parent rebuilds
class GreetingCard extends StatelessWidget {
  // Properties are final (immutable)
  final String name;
  final String message;

  // Constructor with required named parameters
  const GreetingCard({
    super.key,
    required this.name,
    this.message = 'Welcome!',
  });


//using of override, Use my version of build() instead of the default empty one.
  @override
  //build is the ui generator method 
  Widget build(BuildContext context) {
    // build() is called when widget needs to render
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $name!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}


// Using the widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //widget tree is creating 
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Greeting Cards')),
        body: const Column(
          children: [
            //flutter create build for each greeting card
            GreetingCard(name: 'Alice'),
            GreetingCard(name: 'Bob', message: 'Good to see you!'),
            GreetingCard(name: 'Charlie', message: 'Have a great day!'),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());