// A simple demo of provider and shared_preferences based on the Example app.
//
// NOTE: this does not work in dartpad.dev, presumably due to a lack of
// support for shared_preferences.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Get our prefs at startup because doing it in the widgets is ugly.
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferencesAsync prefsAsync = SharedPreferencesAsync();
  final startingHighScore = await prefsAsync.getInt('highScore') ?? 0;
  debugPrint("starting high score is $startingHighScore");

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter(startingHighScore)),
      ],
      child: const MyApp(),
    ),
  );
}

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int _highScore = 0;

  Counter(int savedHighScore) : _highScore = savedHighScore;

  int get highScore => _highScore;
  int get count => _count;

  final SharedPreferencesAsync _prefsAsync = SharedPreferencesAsync();

  Future<void> increment() async {
    _count++;

    if (_count > _highScore) {
      debugPrint("setting new high score of $_count");
      _highScore = _count;
      await _prefsAsync.setInt('highScore', _highScore);
    }

    // Notify to rebuild the Count and HighScore widgets:
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Count(),
            Divider(),
            Text('High Score:'),
            HighScore(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_floatingActionButton'),

        /// Calls `context.read` instead of `context.watch` so that it does not rebuild
        /// when [Counter] changes.
        onPressed: () async {
          await context.read<Counter>().increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Count extends StatelessWidget {
  const Count({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
      '${context.watch<Counter>().count}',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class HighScore extends StatelessWidget {
  const HighScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      /// Calls `context.watch` to make [HighScore] rebuild when [Counter] changes.
      '${context.watch<Counter>().highScore}',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
