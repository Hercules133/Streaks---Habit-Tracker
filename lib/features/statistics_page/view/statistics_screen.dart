import 'package:flutter/material.dart';
import 'package:peanutprogress/features/statistics_page/view/bar_chart_widget.dart';
import 'package:peanutprogress/features/statistics_page/view/pie_chart_widget.dart';
import '/core/widgets/app_bar_widget.dart';
import '/core/widgets/drawer_menu_widget.dart';
import '/features/home_page/view/heat_map_widget.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        appBarTitle: 'Statistics',
      ),
      drawer: const MyDrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MyHeatMap(),
            const Text('Diagrams'),
            PieChartWidget(),
            BarChartWidget(),
            // https://pub.dev/packages/d_chart
            // https://pub.dev/packages/graphic
            // https://pub.dev/packages/syncfusion_flutter_charts
            // https://pub.dev/packages/fl_chart
            // https://pub.dev/packages/interactive_chart
          ],
        ),
      ),
    );
  }
}
