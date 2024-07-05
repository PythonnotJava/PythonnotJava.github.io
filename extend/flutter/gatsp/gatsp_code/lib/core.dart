/// [cityNumbers] : 这个参数指的是基因的长度，通常用来表示问题的解或个体的编码长度。在旅行商问题中，[cityNumbers]可以表示城市的数量，即有多少个基因就表示有多少个城市。
/// [popNumbers] : 这个参数表示种群中个体的数量，即在每一代中会有多少个解同时存在。种群中的每个个体都是一种可能的解决方案。
/// [genNumbers] : 这是遗传算法中的代数，表示算法将运行多少代来寻找最优解。每一代代表一轮进化，通过选择、交叉和变异操作来更新种群中的个体。
/// [mutateProb] : 变异概率，表示在每次个体进行变异操作时，每个基因发生变异的概率。变异是为了保持种群的多样性，有助于跳出局部最优解。
library;

import 'dart:math';
// 随机生成路径邻接矩阵的方法
List<List<int>> generateDistanceMatrix(int size) {
  List<List<int>> matrix = List.generate(size, (_) => List.filled(size, 0));
  Random rand = Random();

  for (int i = 0; i < size; i++) {
    for (int j = i + 1; j < size; j++) {
      int distance = rand.nextInt(20) + 1; // 距离为1到20之间的随机数
      matrix[i][j] = distance;
      matrix[j][i] = distance;
    }
  }
  return matrix;
}

// 生成邻接矩阵的markdown代码
String generateMarkdownTable(List<List<int>> matrix) {
  int size = matrix.length;
  StringBuffer buffer = StringBuffer();

  // Generate header
  buffer.write('|   |');
  for (int i = 0; i < size; i++) {
    buffer.write(' ${String.fromCharCode(65 + i)} |');
  }
  buffer.write('\n|---|');
  for (int i = 0; i < size; i++) {
    buffer.write('----|');
  }
  buffer.write('\n');

  // Generate rows
  for (int i = 0; i < size; i++) {
    buffer.write('| ${String.fromCharCode(65 + i)} |');
    for (int j = 0; j < size; j++) {
      buffer.write(' ${matrix[i][j]} |');
    }
    buffer.write('\n');
  }

  return buffer.toString();
}

// const cityNumbers = 5;
// const popNumbers = 60;
// const genNumbers = 50;
// const mutateProb = .25;
//
// // 模拟城市道路——基于邻接矩阵
// List<List<int>> distanceMatrix = [
//   [0, 2, 9, 10, 7],
//   [2, 0, 6, 4, 3],
//   [9, 6, 0, 8, 5],
//   [10, 4, 8, 0, 3],
//   [7, 3, 5, 3, 0],
// ];

class Tour {
  late List<int> cities;
  late int cityNumbers;
  late int popNumbers;
  late int genNumbers;
  late double mutateProb;
  late List<List<int>> distanceMatrix;

  // 传入表示城市的索引即可——比如：A~E五个城市可以用0~4五个数表示
  // 同时索引也可以很好的表示对每个城市的编码，索引对换位置，相当于城市先后顺序变了
  Tour({
    required this.distanceMatrix,
    required this.cities,
    required this.cityNumbers,
    required this.popNumbers,
    required this.genNumbers,
    required this.mutateProb
  });
  // 计算行程总距离
  int calculateDistance() {
    int totalDistance = 0;
    for (int i = 0; i < cityNumbers - 1; i++) {
      totalDistance += distanceMatrix[cities[i]][cities[i + 1]];
    }
    totalDistance += distanceMatrix[cities.last][cities.first];
    // print("totalDistance : $totalDistance");
    return totalDistance;
  }

  // 变异——交换变异
  void mutate() {
    // 随机生成一个0~1的数，表示概率，低于变异概率即发生变异
    if (Random().nextDouble() < mutateProb) {
      // 介于0（包含）和 cityNumbers（不包含）之间的随机整数
      int index1 = Random().nextInt(cityNumbers);
      int index2 = Random().nextInt(cityNumbers);
      int temp = cities[index1];
      cities[index1] = cities[index2];
      cities[index2] = temp;
    }
  }
}

class GeneticAlgorithm {

  late List<int> cities;
  late int cityNumbers;
  late int popNumbers;
  late int genNumbers;
  late double mutateProb;
  late List<List<int>> distanceMatrix;
  // 种群
  List<Tour> population = [];

  GeneticAlgorithm({
    required this.distanceMatrix,
    required this.cities,
    required this.cityNumbers,
    required this.popNumbers,
    required this.genNumbers,
    required this.mutateProb
  }){
    // 创建并且初始化随机种群
    for (int i = 0; i < popNumbers; i++) {
      List<int> randomTour = List.generate(cityNumbers, (int index) => index);
      randomTour.shuffle();
      population.add(
          Tour(
              distanceMatrix: distanceMatrix,
              cities: cities,
              popNumbers: popNumbers,
              genNumbers: genNumbers,
              mutateProb: mutateProb,
              cityNumbers: cityNumbers
          )
      );
    }
  }

  // 基于锦标赛方案筛选
  // 选的指标是总路程
  List<Tour> selection() {
    List<Tour> selectedParents = [];
    for (int i = 0; i < popNumbers; i++) {
      int index1 = Random().nextInt(popNumbers);
      int index2 = Random().nextInt(popNumbers);
      Tour parent1 = population[index1];
      Tour parent2 = population[index2];
      selectedParents.add(parent1.calculateDistance() < parent2.calculateDistance() ? parent1 : parent2);
    }
    return selectedParents;
  }

  // 交叉
  List<Tour> crossover(List<Tour> parents) {
    List<Tour> offspring = [];
    for (int i = 0; i < parents.length; i += 2) {
      Tour parent1 = parents[i];
      Tour parent2 = parents[i + 1];

      // 选段
      List<int> child1 = List.filled(cityNumbers, -1);
      List<int> child2 = List.filled(cityNumbers, -1);

      int startPos = Random().nextInt(cityNumbers);
      int endPos = Random().nextInt(cityNumbers - startPos) + startPos;

      for (int j = startPos; j <= endPos; j++) {
        child1[j] = parent1.cities[j];
        child2[j] = parent2.cities[j];
      }
      // 确保交叉区间外的基因不重复，调整重复基因的位置。
      for (int j = 0; j < cityNumbers; j++) {
        if (!child1.contains(parent2.cities[j])) {
          for (int k = 0; k < cityNumbers; k++) {
            if (child1[k] == -1) {
              child1[k] = parent2.cities[j];
              break;
            }
          }
        }
        if (!child2.contains(parent1.cities[j])) {
          for (int k = 0; k < cityNumbers; k++) {
            if (child2[k] == -1) {
              child2[k] = parent1.cities[j];
              break;
            }
          }
        }
      }

      offspring.add(Tour(
          distanceMatrix: distanceMatrix,
          cities: child1,
          popNumbers: popNumbers,
          genNumbers: genNumbers,
          mutateProb: mutateProb,
          cityNumbers: cityNumbers
      ));
      offspring.add(Tour(
          distanceMatrix: distanceMatrix,
          cities: child2,
          popNumbers: popNumbers,
          genNumbers: genNumbers,
          mutateProb: mutateProb,
          cityNumbers: cityNumbers
      ));
    }
    return offspring;
  }

  // 迭代进化
  Map<String, String> evolve() {
    List<String> results = [];
    String finalResult = '';

    for (int generation = 0; generation < genNumbers; generation++) {
      List<Tour> parents = selection();
      List<Tour> offspring = crossover(parents);

      for (Tour tour in offspring) {
        tour.mutate();
      }

      // 适者生存
      population = List.from(offspring);

      // 每代结束后输出当前最佳路径和距离
      Tour bestTour = population.reduce((a, b) => a.calculateDistance() < b.calculateDistance() ? a : b);
      int bestDistance = bestTour.calculateDistance();
      results.add("Generation $generation: Best tour: ${bestTour.cities}, Distance: $bestDistance");
    }

    // 最终输出最优解
    Tour bestTour = population.reduce((a, b) => a.calculateDistance() < b.calculateDistance() ? a : b);
    int bestDistance = bestTour.calculateDistance();
    finalResult = "Final best tour: ${bestTour.cities}, Distance: $bestDistance";

    return {
      'allResults': results.join('\n'),
      'finalResult': finalResult
    };
  }
}

// void main() {
//   GeneticAlgorithm ga = GeneticAlgorithm(
//       distanceMatrix: generateDistanceMatrix(cityNumbers),
//       cities: List.generate(cityNumbers, (e) => e),
//       cityNumbers: cityNumbers,
//       popNumbers: popNumbers,
//       mutateProb: mutateProb,
//       genNumbers: genNumbers
//   );
//   Map<String, String> result = ga.evolve();
//   print(result['allResults']);
//   print(result['finalResult']);
// }
