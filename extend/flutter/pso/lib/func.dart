import 'core.dart';


// 参数设置
// const n_particles = 30;  // 粒子数，也就是种群数目
// const n_iterations = 100;  // 迭代次数
// const lb = -4.0;  // 上下限
// const ub = 4.0;

// 目标函数
MatrixType objectiveFunc({required MatrixType x}) => x * (x * 2).sin - x * 5 * (x * 2).cos;

// 初始化粒子位置和速度
List<MatrixType> initialize_particles({
  required int n_particles,
  int dim = 1,
  required double lb,
  required double ub,
  int? seed
}){
  final pos = MatrixType.uniform(row: n_particles, column: dim, start: lb, end: ub, seed: seed);
  final vel = MatrixType.uniform(row: n_particles, column: dim, start: -1.0, end: 1.0, seed: seed);
  return [pos, vel];
}

// 计算适应度值
MatrixType calculate_fitness({required MatrixType pos}) => objectiveFunc(x : pos);

List update_best_positions({
  required MatrixType pos,
  required MatrixType fitness,
  required MatrixType pbest,
  required MatrixType pbest_value,
  required double gbest,
  required double gbest_value
}){
  List<List<bool>> better_idx = fitness < pbest_value;
  for (int r = 0;r < better_idx.length;r++){
    for (int c = 0;c < better_idx[0].length;c ++){
      if (better_idx[r][c]){
        pbest[r][c] = pos[r][c];
        pbest_value[r][c] = fitness[r][c];
      }
    }
  }
  int current_best_idx = fitness.argmin(dim: -1) as int;
  double current_best_value = fitness.min(dim: -1) as double;
  if (current_best_value < gbest_value){
    gbest = pos[current_best_idx][0];
    gbest_value = current_best_value;
  }
  return [pbest, pbest_value, gbest, gbest_value];
}

// 更新粒子速度和位置
List<MatrixType> update_particles({
  required MatrixType pos,
  required MatrixType vel,
  required MatrixType pbest,
  required double gbest,
  required double w,
  required double c1,
  required double c2
}) {
  MatrixType r1 = MatrixType.uniform(row: pos.shape[0], column: pos.shape[1]);
  MatrixType r2 = MatrixType.uniform(row: pos.shape[0], column: pos.shape[1]);
  vel = (vel * w + r1 * c1 * (pbest - pos) + r2 * c2 * (pos * (-1) + gbest));
  pos += vel;
  return [pos, vel];
}

// 限制粒子位置在边界范围内
MatrixType apply_bounds({required MatrixType pos, required double lb, required double ub})
=> pos.clip(lb: lb, ub: ub);

// 粒子群优化主函数
List pso({
  required int n_particles,
  required int n_iterations,
  required double lb,
  required double ub,
  int? seed
}){
  var a1 = initialize_particles(n_particles:n_particles, dim : 1, lb : lb, ub : ub, seed: seed);
  MatrixType pos = a1[0], vel = a1[1];
  MatrixType pbest = MatrixType.deepCopy(pos);
  MatrixType pbest_value = calculate_fitness(pos: pbest);
  double gbest = pbest[pbest_value.argmin(dim: -1) as int][0];
  double gbest_value = pbest_value.min() as double;
  List<MatrixType> all_positions = [];
  final w = 0.5;  // 惯性权重，控制速度
  final c1 = 1.5;  // 个体学习因子，控制个体往自身最佳路径的偏移趋向
  final c2 = 1.5;  // 社会学习因子，控制个体往全局最佳路径的偏移趋向
  for (int _ = 0;_ < n_iterations;_++){
    all_positions.add(MatrixType.deepCopy(pos));
    MatrixType fitness = calculate_fitness(pos: pos);
    var l = update_best_positions(
        pos: pos,
        fitness:fitness,
        pbest: pbest,
        pbest_value: pbest_value,
        gbest: gbest,
        gbest_value: gbest_value
    );  // return [pbest, pbest_value, gbest, gbest_value]
    pbest = l[0];
    pbest_value = l[1];
    gbest = l[2];
    gbest_value = l[3];
    var l1 = update_particles(pos:pos, vel:vel, pbest:pbest, gbest:gbest, w:w, c1:c1, c2:c2);
    pos = l1[0];
    vel = l1[1];
    pos = apply_bounds(pos:pos,lb: lb,ub: ub);
  }
  return [gbest, gbest_value, all_positions];
}

List core({required int n_particles, required int n_iterations, required int seed}){
  initMp();
  var l = pso(n_particles : n_particles, n_iterations : n_particles, lb: -4.0, ub: 4.0, seed: seed);
  double optimal_x = l[0], optimal_f = l[1];
  freeMp();
  return [optimal_x, optimal_f, paths];
}