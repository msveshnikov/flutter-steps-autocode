// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
  runApp(
    ChangeNotifierProvider(
      create: (context) => StepTrackerModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StepTrackerModel>(
      builder: (context, model, child) {
        return MaterialApp(
          title: 'Steps Tracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: model.themeMode,
          home: const HomePage(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('es', ''),
            Locale('fr', ''),
          ],
        );
      },
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
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
                GoalWidget(model: model),
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

  const StatsWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset('assets/images/walk.png', height: 50),
                    Text('Steps: ${model.steps}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/images/heart.png', height: 50),
                    Text('Calories: ${model.calories.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/images/run.png', height: 50),
                    Text('Distance: ${model.distance.toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final StepTrackerModel model;

  const GraphWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Today\'s Steps', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups:
                      model.todayStepHistory.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [BarChartRodData(toY: entry.value.toDouble())],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Monthly Steps', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups:
                      model.monthlyStepHistory.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [BarChartRodData(toY: entry.value.toDouble())],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final StepTrackerModel model;

  const ControlButtons({super.key, required this.model});

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
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: model.backupData,
            child: const Text('Backup'),
          ),
        ],
      ),
    );
  }
}

class GoalWidget extends StatelessWidget {
  final StepTrackerModel model;

  const GoalWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Daily Goal: ${model.dailyGoal} steps',
                style: const TextStyle(fontSize: 18)),
            LinearProgressIndicator(
              value: model.steps / model.dailyGoal,
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<StepTrackerModel>(
        builder: (context, model, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Sensitivity'),
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
                title: const Text('Sync with Google Fit'),
                trailing: Switch(
                  value: model.syncWithGoogleFit,
                  onChanged: (bool value) {
                    model.setSyncWithGoogleFit(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Sync with Samsung Health'),
                trailing: Switch(
                  value: model.syncWithSamsungHealth,
                  onChanged: (bool value) {
                    model.setSyncWithSamsungHealth(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Daily Goal'),
                subtitle: TextFormField(
                  initialValue: model.dailyGoal.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    model.setDailyGoal(int.parse(value));
                  },
                ),
              ),
              ListTile(
                title: const Text('Height (cm)'),
                subtitle: TextFormField(
                  initialValue: model.height.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    model.setHeight(double.parse(value));
                  },
                ),
              ),
              ListTile(
                title: const Text('Weight (kg)'),
                subtitle: TextFormField(
                  initialValue: model.weight.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    model.setWeight(double.parse(value));
                  },
                ),
              ),
              ListTile(
                title: const Text('Theme'),
                trailing: DropdownButton<ThemeMode>(
                  value: model.themeMode,
                  onChanged: (ThemeMode? newValue) {
                    model.setThemeMode(newValue!);
                  },
                  items: ThemeMode.values.map((ThemeMode mode) {
                    return DropdownMenuItem<ThemeMode>(
                      value: mode,
                      child: Text(mode.toString().split('.').last),
                    );
                  }).toList(),
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
  List<int> _todayStepHistory = List.filled(24, 0);
  List<int> _monthlyStepHistory = List.filled(30, 0);
  bool _isTracking = false;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  double _sensitivity = 50;
  bool _syncWithGoogleFit = false;
  bool _syncWithSamsungHealth = false;
  int _dailyGoal = 6000;
  ThemeMode _themeMode = ThemeMode.system;
  double _height = 184;
  double _weight = 90;
  late Database _database;

  StepTrackerModel() {
    initPlatformState();
    loadData();
    initDatabase();
  }

  int get steps => _steps;
  double get calories => _calories;
  double get distance => _distance;
  String get time => _time.toString().split('.').first;
  List<int> get todayStepHistory => _todayStepHistory;
  List<int> get monthlyStepHistory => _monthlyStepHistory;
  bool get isTracking => _isTracking;
  double get sensitivity => _sensitivity;
  bool get syncWithGoogleFit => _syncWithGoogleFit;
  bool get syncWithSamsungHealth => _syncWithSamsungHealth;
  int get dailyGoal => _dailyGoal;
  ThemeMode get themeMode => _themeMode;
  double get height => _height;
  double get weight => _weight;

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream.listen(onStepCount);
    _pedestrianStatusStream.listen(onPedestrianStatusChanged);
  }

  void onStepCount(StepCount event) {
    if (_isTracking) {
      _steps = event.steps;
      _calories = calculateCalories();
      _distance = calculateDistance();
      updateStepHistory();
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
    _todayStepHistory = List.filled(24, 0);
    saveData();
    notifyListeners();
  }

  double calculateCalories() {
    double caloriesPerStep = 0.04 * (_weight / 70) * (_height / 170);
    return _steps * caloriesPerStep;
  }

  double calculateDistance() {
    double strideLength = _height * 0.415;
    return (_steps * strideLength) / 100000;
  }

  void updateStepHistory() {
    int currentHour = DateTime.now().hour;
    _todayStepHistory[currentHour] = _steps;

    int currentDay = DateTime.now().day - 1;
    _monthlyStepHistory[currentDay] = _steps;
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('steps', _steps);
    prefs.setDouble('calories', _calories);
    prefs.setDouble('distance', _distance);
    prefs.setString('time', _time.toString());
    prefs.setStringList('todayStepHistory',
        _todayStepHistory.map((e) => e.toString()).toList());
    prefs.setStringList('monthlyStepHistory',
        _monthlyStepHistory.map((e) => e.toString()).toList());
    prefs.setDouble('sensitivity', _sensitivity);
    prefs.setBool('syncWithGoogleFit', _syncWithGoogleFit);
    prefs.setBool('syncWithSamsungHealth', _syncWithSamsungHealth);
    prefs.setInt('dailyGoal', _dailyGoal);
    prefs.setInt('themeMode', _themeMode.index);
    prefs.setDouble('height', _height);
    prefs.setDouble('weight', _weight);

    await _database.insert(
      'steps_history',
      {
        'date': DateTime.now().toIso8601String(),
        'steps': _steps,
        'calories': _calories,
        'distance': _distance,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _steps = prefs.getInt('steps') ?? 0;
    _calories = prefs.getDouble('calories') ?? 0;
    _distance = prefs.getDouble('distance') ?? 0;
    _time = Duration(seconds: prefs.getInt('time') ?? 0);
    _todayStepHistory = prefs
            .getStringList('todayStepHistory')
            ?.map((e) => int.parse(e))
            .toList() ??
        List.filled(24, 0);
    _monthlyStepHistory = prefs
            .getStringList('monthlyStepHistory')
            ?.map((e) => int.parse(e))
            .toList() ??
        List.filled(30, 0);
    _sensitivity = prefs.getDouble('sensitivity') ?? 50;
    _syncWithGoogleFit = prefs.getBool('syncWithGoogleFit') ?? false;
    _syncWithSamsungHealth = prefs.getBool('syncWithSamsungHealth') ?? false;
    _dailyGoal = prefs.getInt('dailyGoal') ?? 10000;
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    _height = prefs.getDouble('height') ?? 170;
    _weight = prefs.getDouble('weight') ?? 70;
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

  void setDailyGoal(int value) {
    _dailyGoal = value;
    saveData();
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    saveData();
    notifyListeners();
  }

  void setHeight(double value) {
    _height = value;
    saveData();
    notifyListeners();
  }

  void setWeight(double value) {
    _weight = value;
    saveData();
    notifyListeners();
  }

  Future<void> syncData() async {
    if (_syncWithGoogleFit) {
      // Sync with Google Fit
    }
    if (_syncWithSamsungHealth) {
      // Sync with Samsung Health
    }
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      '${await getDatabasesPath()}/steps_database.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE steps_history(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, steps INTEGER, calories REAL, distance REAL)',
        );
      },
      version: 1,
    );
  }
}
