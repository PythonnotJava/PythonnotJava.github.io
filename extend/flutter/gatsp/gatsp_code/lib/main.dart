import 'package:split_view/split_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'core.dart';
import 'NavigatorScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ga-Tsp-Example',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: MyHomePage(toggleTheme: _toggleTheme),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MyHomePage({super.key, required this.toggleTheme});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLight = true;

  final TextEditingController cityController = TextEditingController(text: '10');
  final TextEditingController populationController = TextEditingController(text: '60');
  final TextEditingController generationController = TextEditingController(text: '50');
  final TextEditingController mutationController = TextEditingController(text: '0.25');
  List<Widget> resultLines = [const Text('等待运行中')];

  @override
  void dispose() {
    cityController.dispose();
    populationController.dispose();
    generationController.dispose();
    mutationController.dispose();
    super.dispose();
  }

  void showAlertDialog(BuildContext context) {

    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () =>Navigator.of(context).pop(),
    );
    // cityNumbers = (cityNumbers <= 25 && cityNumbers > 3) ? cityNumbers : 25;
    // popNumbers = (popNumbers <= 100 && popNumbers >= 10) ? popNumbers : 50;
    // genNumbers = (genNumbers <= 150 && genNumbers >= 50) ? genNumbers : 100;
    // mutateProb = (mutateProb > 0 && mutateProb < 1) ? mutateProb : .25;
    String info = "作者：Mxc\n基于框架：Flutter\n许可证：BSD-3-Clause license\n"
        "城市数量限制：3 < x <= 25\n种群数量限制：10 <= x <= 100\n迭代次数：50 <= x <= 150\n"
        "变异概率：0 < x < 1";
    AlertDialog alert = AlertDialog(
      title: const Text("提示"),
      content: Text(info),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Center(
          child: Text(
            'Ga-Tsp-Example',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 32,
            ),
          ),
        ),
        actions: <Widget>[
          Switch(
            value: isLight,
            onChanged: (value) {
              setState(() {
                isLight = value;
                widget.toggleTheme();
              });
            },
          ),
          Icon(isLight ? Icons.wb_sunny : Icons.nights_stay),
          IconButton(
              onPressed: () => showAlertDialog(context),
              icon:  const Icon(Icons.question_mark),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('城市数量: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: cityController,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('种群数量: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: populationController,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('迭代次数: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: generationController,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('变异概率: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: mutationController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String cityCount = cityController.text;
                    String populationCount = populationController.text;
                    String generationCount = generationController.text;
                    String mutationProbability = mutationController.text;

                    int cityNumbers = int.parse(cityCount);
                    int popNumbers = int.parse(populationCount);
                    int genNumbers = int.parse(generationCount);
                    double mutateProb = double.parse(mutationProbability);
                    List<List<int>> lis = generateDistanceMatrix(cityNumbers);

                    // 限制一下
                    cityNumbers = (cityNumbers <= 25 && cityNumbers > 3) ? cityNumbers : 25;
                    popNumbers = (popNumbers <= 100 && popNumbers >= 10) ? popNumbers : 50;
                    genNumbers = (genNumbers <= 150 && genNumbers >= 50) ? genNumbers : 100;
                    mutateProb = (mutateProb > 0 && mutateProb < 1) ? mutateProb : .25;

                    GeneticAlgorithm ga = GeneticAlgorithm(
                        distanceMatrix: lis,
                        cities: List.generate(cityNumbers, (e) => e),
                        cityNumbers: cityNumbers,
                        popNumbers: popNumbers,
                        mutateProb: mutateProb,
                        genNumbers: genNumbers
                    );
                    Map<String, String> results = ga.evolve();

                    setState(() {
                      resultLines.clear();
                      resultLines.add(Text('当前$cityNumbers个城市的邻接矩阵表如下：'));
                      resultLines.add(
                        TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Navigatorscreen(lis: lis,),
                                ),
                              );
                            },
                            child:const Text('点击查看表示城市距离的邻接矩阵')
                        )
                      );
                      List<String> l1 = results['allResults']!.split('\n');
                      resultLines.addAll(
                          List<Widget>.generate(l1.length, (e) => Text(l1[e]))
                      );
                      resultLines.add(Text('最终种群 ${results['finalResult']}'));
                    });

                  },
                  child: const Text('Run'),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 5,
          ),
          Expanded(
            child: SplitView(
              viewMode: SplitViewMode.Horizontal,
              gripSize: 5.0,
              children: [
                Column(
                  children: [
                    const Text(
                      '核心代码',
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: rootBundle.loadString('assets/doc.md'),
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
                      '运行结果',
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: resultLines.length,
                        itemBuilder: (context, index) {
                          return resultLines[index];
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
