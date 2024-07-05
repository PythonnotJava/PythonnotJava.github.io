import 'package:flutter_markdown/flutter_markdown.dart' show Markdown;
import 'package:flutter/material.dart';

import 'core.dart' show generateMarkdownTable;

class Navigatorscreen extends StatelessWidget {
  late List<List<int>> lis;
  Navigatorscreen({super.key, required this.lis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('表示城市距离的邻接矩阵'),
      ),
      body: Markdown(data: generateMarkdownTable(lis),),
    );
  }
}