import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  // final List<charts.Series<HistoryRecord, DateTime>> seriesList;
  // const HistoryPage({
  //   Key? key,
  //   required this.seriesList,
  // }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   final max = seriesList[0].data.fold<int>(0, (value, element) => math.max(value, element.wpm));

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("History"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(20),
  //         child: charts.TimeSeriesChart(
  //           seriesList,
  //           animate: true,
  //           // defaultRenderer: charts.BarRendererConfig<DateTime>(),
  //           defaultInteractions: false,
  //           primaryMeasureAxis: const charts.NumericAxisSpec(
  //             viewport: charts.NumericExtents(0.0, 100.0),
  //           ),
  //           behaviors: [
  //             charts.SelectNearest(),
  //             charts.DomainHighlighter(),
  //             charts.ChartTitle('Word per minute',
  //               behaviorPosition: charts.BehaviorPosition.bottom,
  //               titleOutsideJustification:
  //                   charts.OutsideJustification.middleDrawArea),
  //             charts.RangeAnnotation([
  //               charts.LineAnnotationSegment(
  //               max, charts.RangeAnnotationAxisType.measure,
  //               endLabel: "max $max wpm",
  //               color: charts.MaterialPalette.gray.shade400
  //               ),
  //             ]),
  //           ]
  //         ),
  //       ),
  //     );
  // }
}