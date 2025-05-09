part of 'core.dart';
final paths = path.join(Directory.current.path, 'assets/matply.dll');
final dylib = DynamicLibrary.open(paths);

// const VERSION = '1.0.5';

// String pubCacheDir = path.join(
//     Platform.environment['LOCALAPPDATA']!,
//     'Pub',
//     'Cache',
//     'hosted',
//     'pub.dev',
//     'matply-$VERSION'
// );  // 对1.0.0版本的路径问题的修复，查找pub下载cache路径，如果每个人不一样，可以通过设置pubCacheDir即可
//
// final dylib = DynamicLibrary.open(path.join(pubCacheDir, 'lib/src/C', 'matply.dll'));

Pointer<Double> _Pi = dylib.lookup('PI').cast<Double>();
Pointer<Double> _e = dylib.lookup('e').cast<Double>();
Pointer<Double> _nan = dylib.lookup('_nan').cast<Double>();
Pointer<Double> _inf = dylib.lookup('inf').cast<Double>();

/// global functions
typedef set__visible__round__base__ffi = Void Function(Pointer<Utf8> new_round);
typedef set__visible__round__base = void Function(Pointer<Utf8> new_round);
final set__visible__round__base matply__set__visible__round = dylib.lookupFunction<set__visible__round__base__ffi, set__visible__round__base>('set_visible_round');

typedef set__round__base__ffi = Void Function(Double number);
typedef set__round__base = void Function(double number);
final set__round__base matply__set__round = dylib.lookupFunction<set__round__base__ffi, set__round__base>('set_round');

typedef get__visible__round__base__ffi = Pointer<Utf8> Function();
typedef get__visible__round__base = Pointer<Utf8> Function();
final get__visible__round__base matply__get__visible__round = dylib.lookupFunction<get__visible__round__base__ffi, get__visible__round__base>('get_visible_round');

typedef get__round__base__ffi = Double Function();
typedef get__round__base = double Function();
final get__round__base matply__get__round = dylib.lookupFunction<get__round__base__ffi, get__round__base>('get_round');

// 定义与SpecialAttributes结构体对应的Dart结构体
final class SpecialAttributes extends Struct {
  @Bool()
  external bool identityMatrix;

  @Bool()
  external bool principalDiagonalMatrix;

  @Bool()
  external bool subDiagonalMatrix;

  @Bool()
  external bool upperTriangularMatrix;

  @Bool()
  external bool lowerTriangularMatrix;

  @Bool()
  external bool singularMatrix;
}

// 定义与Matrix结构体对应的Dart结构体
final class Matrix extends Struct {
  @Int32()
  external int row;

  @Int32()
  external int column;

  external Pointer<SpecialAttributes> spc;

  external Pointer<Pointer<Double>> data;
}

// 定义DLL中的函数
typedef __new__base__ffi = Pointer<Matrix> Function(Int32 row, Int32 column);
typedef __new__base = Pointer<Matrix> Function(int row, int column);

typedef __init__base__ffi = Pointer<Matrix> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Pointer<SpecialAttributes> spc);
typedef __init__base = Pointer<Matrix> Function(int row, int column, Pointer<Pointer<Double>> data, Pointer<SpecialAttributes> spc);

typedef VisibleMatrix__base__ffi = Void Function(Pointer<Matrix> matrix);
typedef VisibleMatrix__base = void Function(Pointer<Matrix> matrix);

typedef __delete__base__ffi = Void Function(Pointer<Matrix> matrix);
typedef __delete__base = void Function(Pointer<Matrix> matrix);

typedef __delete__data__base__ffi = Void Function(Pointer<Pointer<Double>> data, Int32 row);
typedef __delete__data__base = void Function(Pointer<Pointer<Double>> data, int row);

typedef filled__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column, Double number);
typedef filled__base = Pointer<Pointer<Double>> Function(int row, int column, double number);

typedef zeros__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column);
typedef zeros__base = Pointer<Pointer<Double>>Function(int row, int column);

typedef ones__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column);
typedef ones__base = Pointer<Pointer<Double>> Function(int row, int column);

typedef VisibleMatrixSpc__base__ffi = Void Function(Pointer<Matrix> matrix);
typedef VisibleMatrixSpc__base = void Function(Pointer<Matrix> matrix);

typedef row__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data);
typedef row__base = Pointer<Double> Function( int row,  int column, Pointer<Pointer<Double>> data);

typedef column__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data);
typedef column__base = Pointer<Double> Function( int row,  int column, Pointer<Pointer<Double>> data);

typedef at__base__ffi = Double Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data);
typedef at__base = double Function(int row, int column, Pointer<Pointer<Double>> data);

typedef transpose__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data);
typedef transpose__base = Pointer<Pointer<Double>> Function(int row, int column, Pointer<Pointer<Double>> data);

typedef exchangeR__base__ffi = Void Function(Int32 column, Pointer<Pointer<Double>> data, Int32 row1, Int32 row2);
typedef exchangeR__base = void Function(int column, Pointer<Pointer<Double>> data, int row1, int row2);

typedef multiplyR__base__ffi = Void Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double size);
typedef multiplyR__base = void Function(int row, int column, Pointer<Pointer<Double>> data, double size);

typedef addR__base__ffi = Void Function( Int32 column, Pointer<Pointer<Double>> data, Int32 row1, Int32 row2, Double size);
typedef addR__base = void Function( int column, Pointer<Pointer<Double>> data, int row1, int row2, double size);

typedef exchangeC__base__ffi = Void Function( Int32 row, Pointer<Pointer<Double>> data, Int32 column1,Int32 column2);
typedef exchangeC__base = void Function( int row, Pointer<Pointer<Double>> data, int column1, int column2);

typedef multiplyC__base__ffi = Void Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double size);
typedef multiplyC__base = void Function( int row, int column, Pointer<Pointer<Double>> data, double size);

typedef addC__base__ffi = Void Function(Int32 row, Pointer<Pointer<Double>> data, Int32 column1, Int32 column2, Double size);
typedef addC__base = void Function( int row, Pointer<Pointer<Double>> data, int column1, int column2, double size);

typedef addNumber__base__ffi = Pointer<Pointer<Double>> Function( Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double number);
typedef addNumber__base = Pointer<Pointer<Double>> Function( int row, int column,  Pointer<Pointer<Double>> data, double number);

typedef addNumberNoReturned__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data, Double number);
typedef addNumberNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>> data, double number);

typedef addMatrix__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data1, Pointer<Pointer<Double>> data2);
typedef addMatrix__base = Pointer<Pointer<Double>> Function( int row, int column, Pointer<Pointer<Double>> data1, Pointer<Pointer<Double>> data2);

typedef addMatrixNoReturned__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2);
typedef addMatrixNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>> data1, Pointer<Pointer<Double>> data2);

typedef minusMatrix__base__ffi = Pointer<Pointer<Double>> Function( Int32 row, Int32, Pointer<Pointer<Double>> data1, Pointer<Pointer<Double>> data2);
typedef minusMatrix__base = Pointer<Pointer<Double>> Function( int row, int column, Pointer<Pointer<Double>> data1, Pointer<Pointer<Double>> data2);

typedef minusMatrixNoReturned__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data1, Pointer<Pointer<Double>> data2);
typedef minusMatrixNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2);

typedef matmul__base__ffi = Pointer<Pointer<Double>> Function( Int32 row, Int32 column,  Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2, Int32 column2);
typedef matmul__base = Pointer<Pointer<Double>> Function( int row,  int column, Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2, int column2);

typedef multiplyMatrixNoReturned__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2);
typedef multiplyMatrixNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2);

typedef multiplyMatrix__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2);
typedef multiplyMatrix__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>> data2);

typedef multiplyNumberNoReturned__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data,  Double number);
typedef multiplyNumberNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>> data,  double number);

typedef multiplyNumber__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data,  Double number);
typedef multiplyNumber__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>> data,  double number);

typedef kronecker__base__ffi = Pointer<Pointer<Double>> Function( Int32 row1,  Int32 column1,  Pointer<Pointer<Double>> data1,  Int32 row2,  Int32 column2,  Pointer<Pointer<Double>> data2);
typedef kronecker__base = Pointer<Pointer<Double>> Function( int row1,  int column1,  Pointer<Pointer<Double>> data1,  int row2,  int column2,  Pointer<Pointer<Double>> data2);

typedef divide__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column, Pointer<Pointer<Double>> data,  Double number);
typedef divide__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>> data,  double number);

typedef divideNoReturned__base__ffi = Void Function( Int32 row,  Int32, Pointer<Pointer<Double>> data,  Double number);
typedef divideNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>> data,  double number);

typedef arrange__base__ffi = Pointer<Pointer<Double>> Function(Double start, Int32 row, Int32 column);
typedef arrange__base = Pointer<Pointer<Double>> Function(double start, int row, int column);

typedef linspace__base__ffi = Pointer<Pointer<Double>> Function(Double start, Double end, Int32 row, Int32 column, Bool keep);
typedef linspace__base = Pointer<Pointer<Double>> Function(double start, double end, int row, int column, bool keep);

typedef trace__base__ffi = Double Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data);
typedef trace__base = double Function( int row,  int column,  Pointer<Pointer<Double>> data);

typedef det__base__ffi = Double Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data);
typedef det__base = double Function( int row,  int column,  Pointer<Pointer<Double>> data);

typedef E__base__ffi = Pointer<Pointer<Double>> Function(Int32 n);
typedef E__base = Pointer<Pointer<Double>> Function(int n);

typedef cofactor__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 prow,  Int32 pcolumn);
typedef cofactor__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int prow,  int pcolumn);

typedef inverse__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef inverse__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef adjugate__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef adjugate__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef deepcopy__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef deepcopy__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef compare__base__ffi = Pointer<Pointer<Bool>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>>  data2,  Int32 mode);
typedef compare__base = Pointer<Pointer<Bool>> Function(int row,  int column,  Pointer<Pointer<Double>> data1,  Pointer<Pointer<Double>>  data2,  int mode);

typedef sum__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data,  Int32 dim);
typedef sum__base = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>> data,  int dim);

typedef mean__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data,  Int32 dim);
typedef mean__base = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>> data,  int dim);

typedef min__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data,  Int32 dim);
typedef min__base = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>> data,  int dim);

typedef max__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>> data,  Int32 dim);
typedef max__base = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>> data,  int dim);

typedef data_isSame__base__ffi = Bool Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data1,  Pointer<Pointer<Double>>  data2);
typedef data_isSame__base = bool Function( int row,  int column,  Pointer<Pointer<Double>>  data1,  Pointer<Pointer<Double>>  data2);

typedef spc__isSame__base__ffi = Bool Function(Pointer<SpecialAttributes> spc1, Pointer<SpecialAttributes> spc2);
typedef spc__isSame__base = bool Function(Pointer<SpecialAttributes> spc1, Pointer<SpecialAttributes> spc2);

typedef cut__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 prow,  Int32 pcolumn,  Int32 width,  Int32 height);
typedef cut__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int prow,  int pcolumn,  int width,  int height);

typedef cutfree__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 prow,  Int32 pcolumn, Int32 width,  Int32 height,  Double number);
typedef cutfree__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int prow,  int pcolumn,  int width,  int height,  double number);

typedef concatR__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column1,  Int32 column2,  Pointer<Pointer<Double>>  data1,  Pointer<Pointer<Double>>  data2);
typedef concatR__base = Pointer<Pointer<Double>> Function( int row,  int column1,  int column2,  Pointer<Pointer<Double>>  data1,  Pointer<Pointer<Double>>  data2);

typedef concatC__base__ffi = Pointer<Pointer<Double>> Function( Int32 row1,  Int32 row2,  Int32 column,  Pointer<Pointer<Double>>  data1,  Pointer<Pointer<Double>>  data2);
typedef concatC__base = Pointer<Pointer<Double>> Function( int row1,  int row2,  int column,  Pointer<Pointer<Double>>  data1,  Pointer<Pointer<Double>>  data2);

typedef resizeR__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 origin_row,  Int32 origin_column,  Double number);
typedef resizeR__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int origin_row,  int origin_column,  double number);

typedef resizeC__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 origin_row,  Int32 origin_column,  Double number);
typedef resizeC__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int origin_row,  int origin_column,  double number);

typedef reshape__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 origin_column);
typedef reshape__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int origin_column);

typedef setSeed__base__ffi = Void Function(Int32 seed);
typedef setSeed__base = void Function(int seed);

typedef mathBasement1__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 mode);
typedef mathBasement1__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int mode);

typedef mathBasement2__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 mode, Double number);
typedef mathBasement2__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int mode, double number);

typedef mathBasement2reverse__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 mode, Double number);
typedef mathBasement2reverse__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int mode, double number);

typedef allocateButNoNumbers__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column);
typedef allocateButNoNumbers__base = Pointer<Pointer<Double>> Function(int row, int column);

typedef sigmoid__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef sigmoid__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef softmax__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 dim,  Double mask_nan,  Double mask_inf,  Double mask_neginf);
typedef softmax__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data,  int dim,  double mask_nan,  double mask_inf,  double mask_neginf);

typedef shuffle__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>>  data);
typedef shuffle__base = void Function( int row,  int column, Pointer<Pointer<Double>>  data);

typedef sortNoReturned__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>>  data,  Bool reverse,  Int32 dim,  Double mask_nan);
typedef sortNoReturned__base = void Function( int row,  int column, Pointer<Pointer<Double>>  data,  bool reverse,  int dim,  double mask_nan);

typedef sort__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column, Pointer<Pointer<Double>>  data,  Bool reverse,  Int32 dim,  Double mask_nan);
typedef sort__base = Pointer<Pointer<Double>> Function(int row,  int column, Pointer<Pointer<Double>>  data,  bool reverse,  int dim,  double mask_nan);

typedef uniform__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Double start,  Double end,  Int32 seed,  Bool use);
typedef uniform__base = Pointer<Pointer<Double>> Function( int row,  int column,  double start,  double end,  int seed,  bool use);

typedef normal__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Double mu,  Double sigma,  Int32 seed,  Bool use);
typedef normal__base = Pointer<Pointer<Double>> Function( int row,  int column,  double mu,  double sigma,  int seed,  bool use);

typedef poisson__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Double lambda,  Int32 seed,  Bool use);
typedef poisson__base = Pointer<Pointer<Double>> Function( int row,  int column,  double lambda,  int seed,  bool use);

typedef rref__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef rref__base = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef set_mask_nan__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>>  data,  Double number);
typedef set_mask_nan__base  = void Function( int row,  int column, Pointer<Pointer<Double>>  data,  double number);

typedef set_mask_inf__base__ffi = Void Function( Int32 row,  Int32 column, Pointer<Pointer<Double>>  data,  Double number,  Bool isNegativeInf);
typedef set_mask_inf__base  = void Function( int row,  int column, Pointer<Pointer<Double>>  data,  double number,  bool isNegativeInf);

typedef rank__base__ffi = Int32 Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef rank__base  = int Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef oneTotwoArray__base__ffi = Pointer<Pointer<Double>> Function(Pointer<Double> array, Int32 row, Int32 column);
typedef oneTotwoArray__base = Pointer<Pointer<Double>> Function(Pointer<Double> array, int row, int column);

typedef __init__point__data__base__ffi = Pointer<Matrix> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Pointer<SpecialAttributes> spc);
typedef __init__point__data__base = Pointer<Matrix> Function(int row, int column, Pointer<Pointer<Double>> data, Pointer<SpecialAttributes> spc);

typedef variance__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Bool sample, Int32 dim, Bool std);
typedef variance__base  = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>>  data, bool sample, int dim, bool std);

typedef median__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data,  Int32 dim);
typedef median__base  = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef norm_negainf__base__ffi = Double Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef norm_negainf__base  = double Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef norm_inf__base__ffi = Double Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef norm_inf__base  = double Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef norm_zero__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 dim);
typedef norm_zero__base  = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef norm_one__base__ffi = Double Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data);
typedef norm_one__base  = double Function( int row,  int column,  Pointer<Pointer<Double>>  data);

typedef norm__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 n, Int32 dim);
typedef norm__base  = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int n, int dim);

typedef argmax__base__ffi = Pointer<Int32> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 dim);
typedef argmax__base  = Pointer<Int32> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef argmin__base__ffi = Pointer<Int32> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 dim);
typedef argmin__base  = Pointer<Int32> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef flatten__base__ffi = Pointer<Double> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 mode);
typedef flatten__base  = Pointer<Double> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int mode);

typedef range__base__ffi = Pointer<Pointer<Double>> Function(Double start, Double step, Int32 row,  Int32 column);
typedef range__base  = Pointer<Pointer<Double>> Function(double start, double step, int row,  int column);

typedef _Cdt = Pointer<NativeFunction<Bool Function(Double)>>;
typedef replace__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double number, _Cdt condition);
typedef replace__base  = Pointer<Pointer<Double>> Function(int row, int column, Pointer<Pointer<Double>> data, double number, _Cdt condition);

typedef replaceNoReturned__base__ffi = Void Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double number, Pointer<NativeFunction<Bool Function(Double)>> condition);
typedef replaceNoReturned__base  = void Function(int row, int column, Pointer<Pointer<Double>> data, double number, Pointer<NativeFunction<Bool Function(Double)>> condition);

typedef normalization1__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 dim);
typedef normalization1__base  = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef normalization2__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 dim);
typedef normalization2__base  = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef normalization3__base__ffi = Pointer<Pointer<Double>> Function( Int32 row,  Int32 column,  Pointer<Pointer<Double>>  data, Int32 dim);
typedef normalization3__base  = Pointer<Pointer<Double>> Function( int row,  int column,  Pointer<Pointer<Double>>  data, int dim);

typedef sliceR__base__ffi = Pointer<Pointer<Double>> Function(Int32 column,  Pointer<Pointer<Double>>  data, Int32 from, Int32 to);
typedef sliceR__base  = Pointer<Pointer<Double>> Function(int column,  Pointer<Pointer<Double>>  data, int from, int to);

typedef sliceC__base__ffi = Pointer<Pointer<Double>> Function( Int32 row, Pointer<Pointer<Double>>  data, Int32 from, Int32 to);
typedef sliceC__base  = Pointer<Pointer<Double>> Function( int row,  Pointer<Pointer<Double>>  data, int from, int to);

typedef clip__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double lb, Double ub);
typedef clip__base  = Pointer<Pointer<Double>> Function(int row, int column, Pointer<Pointer<Double>> data, double lb, double ub);

typedef clipNoReturned__base__ffi = Void Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Double lb, Double ub);
typedef clipNoReturned__base  = void Function(int row, int column, Pointer<Pointer<Double>> data, double lb, double ub);

typedef all__base__ffi = Bool Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, _Cdt condition);
typedef all__base  = bool Function(int row, int column, Pointer<Pointer<Double>> data, _Cdt condition);

typedef any__base__ffi = Bool Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, _Cdt condition);
typedef any__base  = bool Function(int row, int column, Pointer<Pointer<Double>> data, _Cdt condition);

typedef counter__base__ffi = Pointer<Int32> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Int32 dim, _Cdt condition);
typedef counter__base  = Pointer<Int32> Function(int row, int column, Pointer<Pointer<Double>> data, int dim, _Cdt condition);

typedef reduce__base__ffi = Pointer<Double> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data, Int32 dim, Pointer<NativeFunction<Double Function(Double, Double)>> condition, Double init);
typedef reduce__base = Pointer<Double> Function(int row, int column, Pointer<Pointer<Double>> data, int dim, Pointer<NativeFunction<Double Function(Double, Double)>> condition, double init);

typedef qr__base__ffi = Pointer<Pointer<Pointer<Double>>> Function(Int32 row, Int32 column, Pointer<Pointer<Double>> data);
typedef qr__base = Pointer<Pointer<Pointer<Double>>> Function(int row, int column, Pointer<Pointer<Double>> data);

typedef E_like__base__ffi = Pointer<Pointer<Double>> Function(Int32 row, Int32 column);
typedef E_like__base = Pointer<Pointer<Double>> Function(int row, int column);

final __new__base matply__new__ = dylib.lookupFunction<__new__base__ffi, __new__base>('__new__');
final __init__base matply__init__ = dylib.lookupFunction<__init__base__ffi, __init__base>('__init__');
final VisibleMatrix__base matply__VisibleMatrix = dylib.lookupFunction<VisibleMatrix__base__ffi, VisibleMatrix__base>('VisibleMatrix');
final __delete__base matply__delete__ = dylib.lookupFunction<__delete__base__ffi, __delete__base>('__delete__');
final __delete__data__base matply__delete__data__ = dylib.lookupFunction<__delete__data__base__ffi, __delete__data__base>('__delete__data__');
final filled__base matply__filled = dylib.lookupFunction<filled__base__ffi, filled__base>('filled');
final zeros__base matply__zeros = dylib.lookupFunction<zeros__base__ffi, zeros__base>('zeros');
final ones__base matply__ones = dylib.lookupFunction<ones__base__ffi, ones__base>('ones');
final VisibleMatrixSpc__base matply__VisibleMatrixSpc = dylib.lookupFunction<VisibleMatrixSpc__base__ffi, VisibleMatrixSpc__base>('VisibleMatrixSpc');
final row__base matply__row_ = dylib.lookupFunction<row__base__ffi, row__base>('row_');
final column__base matply__column_ = dylib.lookupFunction<column__base__ffi, column__base>('column_');
final at__base matply__at = dylib.lookupFunction<at__base__ffi, at__base>('at');
final transpose__base matply__transpose = dylib.lookupFunction<transpose__base__ffi, transpose__base>('transpose');
final exchangeR__base matply__exchangeR = dylib.lookupFunction<exchangeR__base__ffi, exchangeR__base>('exchangeR');
final multiplyR__base matply__multiplyR = dylib.lookupFunction<multiplyR__base__ffi, multiplyR__base>('multiplyR');
final addR__base matply__addR = dylib.lookupFunction<addR__base__ffi, addR__base>('addR');
final addC__base matply__addC = dylib.lookupFunction<addC__base__ffi, addC__base>('addC');
final exchangeC__base matply__exchangeC = dylib.lookupFunction<exchangeC__base__ffi, exchangeC__base>('exchangeC');
final multiplyC__base matply__multiplyC = dylib.lookupFunction<multiplyC__base__ffi, multiplyC__base>('multiplyC');
final addNumber__base matply__addNumber = dylib.lookupFunction<addNumber__base__ffi, addNumber__base>('addNumber');
final addNumberNoReturned__base matply__addNumberNoReturned = dylib.lookupFunction<addNumberNoReturned__base__ffi, addNumberNoReturned__base>('addNumberNoReturned');
final addMatrix__base matply__addMatrix = dylib.lookupFunction<addMatrix__base__ffi, addMatrix__base>('addMatrix');
final addMatrixNoReturned__base matply__addMatrixNoReturned = dylib.lookupFunction<addMatrixNoReturned__base__ffi, addMatrixNoReturned__base>('addMatrixNoReturned');
final minusMatrix__base matply__minusMatrix = dylib.lookupFunction<minusMatrix__base__ffi, minusMatrix__base>('minusMatrix');
final minusMatrixNoReturned__base matply__minusMatrixNoReturned = dylib.lookupFunction<minusMatrixNoReturned__base__ffi, minusMatrixNoReturned__base>('minusMatrixNoReturned');
final matmul__base matply__matmul = dylib.lookupFunction<matmul__base__ffi, matmul__base>('matmul');
final multiplyMatrixNoReturned__base matply__multiplyMatrixNoReturned = dylib.lookupFunction<multiplyMatrixNoReturned__base__ffi, multiplyMatrixNoReturned__base>('multiplyMatrixNoReturned');
final multiplyMatrix__base matply__multiplyMatrix = dylib.lookupFunction<multiplyMatrix__base__ffi, multiplyMatrix__base>('multiplyMatrix');
final multiplyNumberNoReturned__base matply__multiplyNumberNoReturned = dylib.lookupFunction<multiplyNumberNoReturned__base__ffi, multiplyNumberNoReturned__base>('multiplyNumberNoReturned');
final multiplyNumber__base matply__multiplyNumber = dylib.lookupFunction<multiplyNumber__base__ffi, multiplyNumber__base>('multiplyNumber');
final kronecker__base matply__kronecker = dylib.lookupFunction<kronecker__base__ffi, kronecker__base>('kronecker');
final divide__base matply__divide = dylib.lookupFunction<divide__base__ffi, divide__base>('divide');
final divideNoReturned__base matply__divideNoReturned = dylib.lookupFunction<divideNoReturned__base__ffi, divideNoReturned__base>('divideNoReturned');
final arrange__base matply__arrange = dylib.lookupFunction<arrange__base__ffi, arrange__base>('arrange');
final linspace__base matply__linspace = dylib.lookupFunction<linspace__base__ffi, linspace__base>('linspace');
final trace__base matply__trace = dylib.lookupFunction<trace__base__ffi, trace__base>('trace');
final det__base matply__det = dylib.lookupFunction<det__base__ffi, det__base>('det');
final E__base matply__E = dylib.lookupFunction<E__base__ffi, E__base>('E');
final cofactor__base matply__cofacto = dylib.lookupFunction<cofactor__base__ffi, cofactor__base>('cofactor');
final inverse__base matply__inverse = dylib.lookupFunction<inverse__base__ffi, inverse__base>('inverse');
final adjugate__base matply__adjugate = dylib.lookupFunction<adjugate__base__ffi, adjugate__base>('adjugate');
final deepcopy__base matply__deepcopy = dylib.lookupFunction<deepcopy__base__ffi, deepcopy__base>('deepcopy');
final compare__base matply__compare = dylib.lookupFunction<compare__base__ffi, compare__base>('compare');
final sum__base matply__sum = dylib.lookupFunction<sum__base__ffi, sum__base>('sum');
final mean__base matply__mean = dylib.lookupFunction<mean__base__ffi, mean__base>('mean');
final max__base matply__max = dylib.lookupFunction<max__base__ffi, max__base>('max');
final min__base matply__min = dylib.lookupFunction<min__base__ffi, min__base>('min');
final data_isSame__base matply__data__isSame = dylib.lookupFunction<data_isSame__base__ffi, data_isSame__base>('data_isSame');
final spc__isSame__base matply__spc__isSame = dylib.lookupFunction<spc__isSame__base__ffi, spc__isSame__base>('spc__isSame');
final cut__base matply__cut = dylib.lookupFunction<cut__base__ffi, cut__base>('cut');
final cutfree__base matply__cutfree = dylib.lookupFunction<cutfree__base__ffi, cutfree__base>('cutfree');
final concatR__base matply__concatR = dylib.lookupFunction<concatR__base__ffi, concatR__base>('concatR');
final concatC__base matply__concatC = dylib.lookupFunction<concatC__base__ffi, concatC__base>('concatC');
final resizeR__base matply__resizeR = dylib.lookupFunction<resizeR__base__ffi, resizeR__base>('resizeR');
final resizeC__base matply__resizeC = dylib.lookupFunction<resizeC__base__ffi, resizeC__base>('resizeC');
final reshape__base matply__reshape = dylib.lookupFunction<reshape__base__ffi, reshape__base>('reshape');
final setSeed__base matply__setSeed = dylib.lookupFunction<setSeed__base__ffi, setSeed__base>('setSeed');
final mathBasement1__base matply_mathBasement1 = dylib.lookupFunction<mathBasement1__base__ffi, mathBasement1__base>('mathBasement1');
final mathBasement2__base matply_mathBasement2 = dylib.lookupFunction<mathBasement2__base__ffi, mathBasement2__base>('mathBasement2');
final mathBasement2reverse__base matply_mathBasement2reverse = dylib.lookupFunction<mathBasement2reverse__base__ffi, mathBasement2reverse__base>('mathBasement2reverse');
final allocateButNoNumbers__base matply__allocateButNoNumbers = dylib.lookupFunction<allocateButNoNumbers__base__ffi, allocateButNoNumbers__base>('allocateButNoNumbers');
final sigmoid__base matply__sigmoid = dylib.lookupFunction<sigmoid__base__ffi, sigmoid__base>('sigmoid');
final softmax__base matply__softmax = dylib.lookupFunction<softmax__base__ffi, softmax__base>('softmax');
final shuffle__base matply__shuffle = dylib.lookupFunction<shuffle__base__ffi, shuffle__base>('shuffle');
final sortNoReturned__base matply__sortNoReturned = dylib.lookupFunction<sortNoReturned__base__ffi, sortNoReturned__base>('sortNoReturned');
final sort__base matply__sort = dylib.lookupFunction<sort__base__ffi, sort__base>('sort');
final uniform__base matply__uniform = dylib.lookupFunction<uniform__base__ffi, uniform__base>('uniform');
final normal__base matply__normal = dylib.lookupFunction<normal__base__ffi, normal__base>('normal');
final poisson__base matply__poisson = dylib.lookupFunction<poisson__base__ffi, poisson__base>('poisson');
final rref__base matply__rref = dylib.lookupFunction<rref__base__ffi, rref__base>('rref');
final set_mask_nan__base matply__set_mask_nan = dylib.lookupFunction<set_mask_nan__base__ffi, set_mask_nan__base>('set_mask_nan');
final set_mask_inf__base matply__set_mask_inf = dylib.lookupFunction<set_mask_inf__base__ffi, set_mask_inf__base>('set_mask_inf');
final __init__point__data__base matply__init__point__data__ = dylib.lookupFunction<__init__point__data__base__ffi, __init__point__data__base>('__init__point__data__');
final rank__base matply__rank = dylib.lookupFunction<rank__base__ffi, rank__base>('rank');
final oneTotwoArray__base matply__oneTotwoArray = dylib.lookupFunction<oneTotwoArray__base__ffi, oneTotwoArray__base>('oneTotwoArray');
final variance__base matply__variance = dylib.lookupFunction<variance__base__ffi, variance__base>('variance');
final median__base matply__median = dylib.lookupFunction<median__base__ffi, median__base>('median');
final norm_negainf__base matply__norm_negainf = dylib.lookupFunction<norm_negainf__base__ffi, norm_negainf__base>('norm_negainf');
final norm_inf__base matply__norm_inf = dylib.lookupFunction<norm_inf__base__ffi, norm_inf__base>('norm_inf');
final norm_zero__base matply__norm_zero = dylib.lookupFunction<norm_zero__base__ffi, norm_zero__base>('norm_zero');
final norm_one__base matply__norm_one = dylib.lookupFunction<norm_one__base__ffi, norm_one__base>('norm_one');
final norm__base matply__norm = dylib.lookupFunction<norm__base__ffi, norm__base>('norm');
final argmax__base matply__argmax = dylib.lookupFunction<argmax__base__ffi, argmax__base>('argmax');
final argmin__base matply__argmin = dylib.lookupFunction<argmin__base__ffi, argmin__base>('argmin');
final flatten__base matply__flatten = dylib.lookupFunction<flatten__base__ffi, flatten__base>('flatten');
final range__base matply__range = dylib.lookupFunction<range__base__ffi, range__base>('range');
final replace__base matply__replace = dylib.lookupFunction<replace__base__ffi, replace__base>('replace');
final replaceNoReturned__base matply__replaceNoReturned = dylib.lookupFunction<replaceNoReturned__base__ffi, replaceNoReturned__base>('replaceNoReturned');
final normalization1__base matply__normalization1 = dylib.lookupFunction<normalization1__base__ffi, normalization1__base>('normalization1');
final normalization2__base matply__normalization2 = dylib.lookupFunction<normalization2__base__ffi, normalization2__base>('normalization2');
final normalization3__base matply__normalization3 = dylib.lookupFunction<normalization3__base__ffi, normalization3__base>('normalization3');
final sliceR__base matply__sliceR = dylib.lookupFunction<sliceR__base__ffi, sliceR__base>('sliceR');
final sliceC__base matply__sliceC = dylib.lookupFunction<sliceC__base__ffi, sliceC__base>('sliceC');
final clip__base matply__clip = dylib.lookupFunction<clip__base__ffi, clip__base>('clip');
final clipNoReturned__base matply__clipNoReturned = dylib.lookupFunction<clipNoReturned__base__ffi, clipNoReturned__base>('clipNoReturned');
final all__base matply__all = dylib.lookupFunction<all__base__ffi, all__base>('all');
final any__base matply__any = dylib.lookupFunction<any__base__ffi, any__base>('any');
final counter__base matply__counter = dylib.lookupFunction<counter__base__ffi, counter__base>('counter');
final reduce__base matply__reduce = dylib.lookupFunction<reduce__base__ffi, reduce__base>('reduce');
final qr__base matply__qr = dylib.lookupFunction<qr__base__ffi, qr__base>('qr');
final E_like__base matply_E_like = dylib.lookupFunction<E_like__base__ffi, E_like__base>('E_like');

dynamic debugmatply_api<T>(T Function() func, [String info = 'Error Here']) {
  try {
    return func();
  } catch (e) {
    print('$info: ${e.toString()}');
  }
}

// 测试一个二维数组指针
void TestArrayPointer(int row, int column, Pointer<Pointer<Double>> data){
  for (int r = 0;r < row;r++){
    for (int c = 0;c < column;c ++){
      print(data[r][c]);
    }
  }
}

final double Pi = _Pi.value;
final double e = _e.value;
final double inf = _inf.value;  // 正无穷大，和Dart的内置相通，下同
final double negativeinf = -inf;  // 负无穷大
final double nan = _nan.value;  // 非法数据

/// 全局的内存管理单例
/// 该内存单例允许：凡是创建一个新Matrix实例，都会主动被检测并添加到内存池中，在程序执行完毕后，可以一键释放。
// void initMp(Matrix * matrix);
// void addToMp(Matrix * matrix);
// void freeMp();
// int getInstances();
final void Function(Pointer<Matrix> matrix) __initMp = dylib.lookupFunction<Void Function(Pointer<Matrix> matrix), void Function(Pointer<Matrix> matrix)>('initMp');
final void Function(Pointer<Matrix> matrix) Signal = dylib.lookupFunction<Void Function(Pointer<Matrix> matrix), void Function(Pointer<Matrix> matrix)>('addToMp');
final void Function(bool) __freeMp = dylib.lookupFunction<Void Function(Bool), void Function(bool)>('freeMp');
final int Function() getInstances = dylib.lookupFunction<Int32 Function(), int Function()>('getInstances');
void initMp({Pointer<Matrix>? matrix}) => __initMp(matrix?? nullptr);
void freeMp({bool visible = false}) => __freeMp(visible);