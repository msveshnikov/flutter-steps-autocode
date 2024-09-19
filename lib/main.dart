// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StepTrackerModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Tracker'),
      ),
      body: Consumer<StepTrackerModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Text('Steps: ${model.steps}'),
              Text('Calories: ${model.calories}'),
              Text('Distance: ${model.distance}'),
              Text('Time: ${model.time}'),
              LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: model.stepHistory.asMap().entries.map((entry) {
                        return FlSpot(
                            entry.key.toDouble(), entry.value.toDouble());
                      }).toList(),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: model.toggleTracking,
                child: Text(model.isTracking ? 'Pause' : 'Start'),
              ),
              ElevatedButton(
                onPressed: model.reset,
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: model.backupData,
                child: const Text('Backup to Google Drive'),
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
      _distance = _steps * 0.762;
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
}
