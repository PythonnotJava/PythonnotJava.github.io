import 'dart:math' show cos, sin;
import 'package:split_view/split_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart' show Markdown;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'func.dart' show core;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSunny = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSO by MatPly',
      theme: isSunny ? _sunnyTheme() : _nightTheme(),
      home: MyHomePage(
        isSunny: isSunny,
        onThemeChanged: (bool value) {
          setState(() {
            isSunny = value;
          });
        },
      ),
    );
  }

  ThemeData _sunnyTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black87,
      ),
      useMaterial3: true,
    );
  }

  ThemeData _nightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      useMaterial3: true,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool isSunny;
  final ValueChanged<bool> onThemeChanged;

  const MyHomePage({super.key, required this.isSunny, required this.onThemeChanged});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LineChartData _chartData; // 用于存储生成的图表数据

  final n_particlesCtrl = TextEditingController(text: '30');
  final n_iterationsCtrl = TextEditingController(text: '100');
  final rnCtrl = TextEditingController(text: '10');
  late List<LineChartBarData> points;

  String runt = '等待中';
  int counter = 0;

  @override
  void dispose() {
    n_particlesCtrl.dispose();
    n_iterationsCtrl.dispose();
    rnCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initChartData();
  }

  void showAlertDialog(BuildContext context) {
    String info = "作者：Mxc\n基于框架：Flutter\n许可证：BSD-3-Clause license\n"
        "种群数量限制：20 < x <= 100\n迭代次数：30 <= x <= 200\n"
        "随机种子：任意整数\n"
        "使用说明：该软件每次需要更新数据才能得到新数据，\n"
        "尤其是随机种子，每次计算的最小值都会以红色点形式\n"
        "被展示在函数图像上，且每次计算的最小值都会保留在\n"
        "原来图像上。鼠标放置点上可以数据对比。";
    AlertDialog alert = AlertDialog(
      title: const Text("提示"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info),
            TextButton(
              child: const Text('本文核心计算库MatPly说明'),
              onPressed: () async {
                var url = 'https://www.robot-shadow.cn/src/pkg/MatPly_Dart/site/';
                if (await canLaunchUrl(Uri.parse(url))) {
                  launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _initChartData() {
    double step = (4.0 - -4.0) / 100;
    List<double> xlist = List.generate(100, (e) => -4 + step * e);
    List<double> ylist = List.generate(100, (e) {
      var x = xlist[e];
      return x * sin(x * 2) - x * 5 * cos(x * 2);
    });
    points = [
      LineChartBarData(
        spots: List.generate(100, (e) => FlSpot(xlist[e], ylist[e])),
        isCurved: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
    ];
    LineChartData data = LineChartData(lineBarsData: points);
    _chartData = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PSO by MatPly',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Switch(
            value: widget.isSunny,
            onChanged: (value) {
              widget.onThemeChanged(value);
            },
          ),
          Icon(widget.isSunny ? Icons.sunny : Icons.dark_mode),
          IconButton(
              onPressed: () => showAlertDialog(context),
              icon: const Icon(Icons.info)
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('种群数目: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: n_particlesCtrl,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('迭代次数: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: n_iterationsCtrl,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('设置随机数: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: rnCtrl,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int n1 = int.parse(n_particlesCtrl.text);
                    int n2 = int.parse(n_iterationsCtrl.text);
                    int rn = int.parse(rnCtrl.text);
                    // 像tsp一样添加限制
                    n1 = (n1 >= 20 && n1 <= 100) ? n1 : 30;
                    n2 = (n2 >= 30 && n2 <= 200) ? n2 : 100;
                    late List point;
                    try{
                      point = core(n_particles: n1, n_iterations: n2, seed: rn);
                    } catch(e){
                      point = [-2.0, 0.0, e.toString()];
                    }
                    LineChartBarData newPoint = LineChartBarData(
                      spots: [FlSpot(point[0], point[1])],
                      color: Colors.red,
                      barWidth: 4,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 8,
                            color: Colors.red,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    );

                    setState(() {
                      points.add(newPoint); // 更新图表数据，不会删掉上一次模拟出的数据，这样好做对比
                      runt = '${point[2]} + ${++counter}';
                    });
                  },
                  child: const Text(
                    'Run',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 5),
          Expanded(
            child: SplitView(
              viewMode: SplitViewMode.Horizontal,
              gripSize: 5,
              children: [
                Column(
                  children: [
                    const Text(
                      '核心代码',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: rootBundle.loadString('assets/pso.md'),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Center(child: Text('Failed to load Markdown'));
                            } else {
                              return Markdown(data: snapshot.data ?? '');
                            }
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '粒子群算法效果',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      runt
                    ),
                    Expanded(
                      child:LineChart(_chartData),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
