// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StepTrackerModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('fr', ''),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steps Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<StepTrackerModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                StatsWidget(model: model),
                GraphWidget(model: model),
                ControlButtons(model: model),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  final StepTrackerModel model;

  const StatsWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Steps: ${model.steps}', style: TextStyle(fontSize: 18)),
            Text('Calories: ${model.calories.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            Text('Distance: ${model.distance.toStringAsFixed(2)} km',
                style: TextStyle(fontSize: 18)),
            Text('Time: ${model.time}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final StepTrackerModel model;

  const GraphWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: model.stepHistory.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                  }).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                ),
              ],
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final StepTrackerModel model;

  const ControlButtons({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: model.toggleTracking,
            child: Text(model.isTracking ? 'Pause' : 'Start'),
          ),
          ElevatedButton(
            onPressed: model.reset,
            child: Text('Reset'),
          ),
          ElevatedButton(
            onPressed: model.backupData,
            child: Text('Backup'),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<StepTrackerModel>(
        builder: (context, model, child) {
          return ListView(
            children: [
              ListTile(
                title: Text('Sensitivity'),
                subtitle: Slider(
                  value: model.sensitivity,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: model.sensitivity.round().toString(),
                  onChanged: (double value) {
                    model.setSensitivity(value);
                  },
                ),
              ),
              ListTile(
                title: Text('Sync with Google Fit'),
                trailing: Switch(
                  value: model.syncWithGoogleFit,
                  onChanged: (bool value) {
                    model.setSyncWithGoogleFit(value);
                  },
                ),
              ),
              ListTile(
                title: Text('Sync with Samsung Health'),
                trailing: Switch(
                  value: model.syncWithSamsungHealth,
                  onChanged: (bool value) {
                    model.setSyncWithSamsungHealth(value);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class StepTrackerModel with ChangeNotifier {
  int _steps = 0;
  double _calories = 0;
  double _distance = 0;
  Duration _time = Duration.zero;
  List<int> _stepHistory = [];
  bool _isTracking = false;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  double _sensitivity = 50;
  bool _syncWithGoogleFit = false;
  bool _syncWithSamsungHealth = false;

  StepTrackerModel() {
    initPlatformState();
    loadData();
  }

  int get steps => _steps;
  double get calories => _calories;
  double get distance => _distance;
  String get time => _time.toString().split('.').first;
  List<int> get stepHistory => _stepHistory;
  bool get isTracking => _isTracking;
  double get sensitivity => _sensitivity;
  bool get syncWithGoogleFit => _syncWithGoogleFit;
  bool get syncWithSamsungHealth => _syncWithSamsungHealth;

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream.listen(onStepCount);
    _pedestrianStatusStream.listen(onPedestrianStatusChanged);
  }

  void onStepCount(StepCount event) {
    if (_isTracking) {
      _steps++;
      _calories = _steps * 0.04;
      _distance = _steps * 0.000762;
      _stepHistory.add(_steps);
      saveData();
      notifyListeners();
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    // Handle pedestrian status changes
  }

  void toggleTracking() {
    _isTracking = !_isTracking;
    notifyListeners();
  }

  void reset() {
    _steps = 0;
    _calories = 0;
    _distance = 0;
    _time = Duration.zero;
    _stepHistory.clear();
    saveData();
    notifyListeners();
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('steps', _steps);
    prefs.setDouble('calories', _calories);
    prefs.setDouble('distance', _distance);
    prefs.setString('time', _time.toString());
    prefs.setStringList(
        'stepHistory', _stepHistory.map((e) => e.toString()).toList());
    prefs.setDouble('sensitivity', _sensitivity);
    prefs.setBool('syncWithGoogleFit', _syncWithGoogleFit);
    prefs.setBool('syncWithSamsungHealth', _syncWithSamsungHealth);
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _steps = prefs.getInt('steps') ?? 0;
    _calories = prefs.getDouble('calories') ?? 0;
    _distance = prefs.getDouble('distance') ?? 0;
    _time = Duration(seconds: prefs.getInt('time') ?? 0);
    _stepHistory =
        prefs.getStringList('stepHistory')?.map((e) => int.parse(e)).toList() ??
            [];
    _sensitivity = prefs.getDouble('sensitivity') ?? 50;
    _syncWithGoogleFit = prefs.getBool('syncWithGoogleFit') ?? false;
    _syncWithSamsungHealth = prefs.getBool('syncWithSamsungHealth') ?? false;
    notifyListeners();
  }

  void backupData() async {
    final googleSignIn =
        GoogleSignIn.standard(scopes: [drive.DriveApi.driveFileScope]);
    final account = await googleSignIn.signIn();
    if (account != null) {
      // Implement Google Drive backup logic here
    }
  }

  void setSensitivity(double value) {
    _sensitivity = value;
    saveData();
    notifyListeners();
  }

  void setSyncWithGoogleFit(bool value) {
    _syncWithGoogleFit = value;
    saveData();
    notifyListeners();
  }

  void setSyncWithSamsungHealth(bool value) {
    _syncWithSamsungHealth = value;
    saveData();
    notifyListeners();
  }
}
